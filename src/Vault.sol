// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "./interface/IVault.sol";
import "./interface/IKYC.sol";

contract Vault is IVault, ERC20 {

    using SafeERC20 for ERC20;

    address public kyc;
    address public baseToken;
    address public rewardToken;
    address public owner;

    uint256 public fundingEnd;
    uint256 public threshold;

    uint256 public rewardPerShare;

    Proposal[] public proposals;

    mapping(uint256 => mapping(address => uint256)) public userVotes;
    mapping(uint256 => uint256) public proposalVotes;

    mapping(address => uint256) public userClaimed;

    uint256 public constant DENOM = 1e5;

    modifier onlyOwner {
        require(owner == msg.sender, "only Owner");
        _;
    }

    modifier onlyVerified {
        require(IKYC(kyc).isVerified(msg.sender), "not verified");
        _;
    }

    constructor(
        address _owner, 
        string memory _tokenName, 
        string memory _symbol, 
        address _baseToken, 
        address _rewardToken,
        address _kyc,
        uint256 _fundingEnd,
        uint256 _threshold
        ) ERC20(_tokenName, _symbol) {
            
        owner = _owner;

        baseToken = _baseToken;
        rewardToken = _rewardToken;
        kyc = _kyc;

        fundingEnd = _fundingEnd;
        threshold = _threshold;
    }

    function deposit(uint256 amount) external onlyVerified {
        require(block.timestamp < fundingEnd, "funding finished");

        ERC20(baseToken).safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);

        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external onlyVerified {
        require(block.timestamp < fundingEnd, "funding finished");

        _burn(msg.sender, amount);
        ERC20(baseToken).safeTransfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }

    function distribute(uint256 amount) external onlyOwner onlyVerified {
        require(block.timestamp > fundingEnd, "funding not finished");

        rewardPerShare += amount * 1e18 / totalSupply();
        ERC20(rewardToken).safeTransferFrom(msg.sender, address(this), amount);

        emit Distribute(rewardToken, amount, rewardPerShare);
    }

    function claim() external onlyVerified {
        require(block.timestamp > fundingEnd, "funding not finished");

        uint256 share = balanceOf(msg.sender);
        uint256 claimed = userClaimed[msg.sender];
        uint256 claimable = (rewardPerShare * share / 1e18) - claimed;

        ERC20(rewardToken).safeTransfer(msg.sender, claimable);

        emit Claim(msg.sender, claimable);
    }

    function propose(address target, uint256 amount, string memory title, string memory description, uint256 deadline) external onlyOwner onlyVerified returns(uint256) {
        uint256 id = proposals.length;
        uint256 targetVote = totalSupply() * threshold / DENOM;

        proposals.push(Proposal(target, amount, title, description, deadline, targetVote, false));

        emit ProposalCreated(id, msg.sender, target, amount, title, description, deadline, targetVote);

        return id;
    }

    function vote(uint256 id, uint256 amount) onlyVerified external {
        require(block.timestamp < proposals[id].deadline, "vote finish");
        require(userVotes[id][msg.sender] + amount <= balanceOf(msg.sender), "need token");

        userVotes[id][msg.sender] += amount;
        proposalVotes[id] += amount;

        emit Vote(id, msg.sender, amount);
    }

    function execute(uint256 id) external onlyOwner onlyVerified {
        require(block.timestamp > proposals[id].deadline, "vote not finish");
        require(proposals[id].targetVote <= proposalVotes[id], "rejected");
        require(proposals[id].executed == false, "executed");

        proposals[id].executed = true;

        ERC20(baseToken).safeTransfer(proposals[id].target, proposals[id].amount);

        emit ProposalExecuted(id, true);
    }

}
