// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "./IVault.sol";
contract Vault is IVault, ERC20 {

    using SafeERC20 for ERC20;

    address public baseToken;
    address public owner;

    uint256 public fundingEnd;
    uint256 public threshold;

    Proposal[] public proposals;

    mapping(uint256 => mapping(address => uint256)) public userVotes;
    mapping(uint256 => uint256) public proposalVotes;

    uint256 public constant DENOM = 1e5;

    modifier onlyOwner {
        require(owner == msg.sender, "only Owner");
        _;
    }

    constructor(
        address _owner, 
        string memory _tokenName, 
        string memory _symbol, 
        address _baseToken, 
        uint256 _fundingEnd,
        uint256 _threshold
        ) ERC20(_tokenName, _symbol) {
            
        baseToken = _baseToken;
        owner = _owner;
        fundingEnd = _fundingEnd;
        threshold = _threshold;
    }

    function deposit(uint256 amount) external {
        require(block.timestamp < fundingEnd, "funding finished");

        ERC20(baseToken).safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function propose(address target, uint256 amount, string memory title, string memory description, uint256 deadline) external onlyOwner returns(uint256) {
        uint256 id = proposals.length;
        uint256 targetVote = totalSupply() * threshold / DENOM;
        proposals.push(Proposal(target, amount, title, description, deadline, targetVote));
        emit ProposalCreated(id, msg.sender, target, amount, title, description, deadline, targetVote);
        return id;
    }

    function vote(uint256 id, uint256 amount) external {
        require(block.timestamp < proposals[id].deadline, "vote finish");
        require(userVotes[id][msg.sender] + amount <= balanceOf(msg.sender), "need token");
        userVotes[id][msg.sender] += amount;
        proposalVotes[id] += amount;
        emit Vote(id, msg.sender, amount);
    }



}
