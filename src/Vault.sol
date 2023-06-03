// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "./IVault.sol";
contract Vault is IVault, ERC20 {

    using SafeERC20 for ERC20;

    address baseToken;
    address owner;

    Proposal[] proposals;

    modifier onlyOwner {
        require(owner == msg.sender, "only Owner");
        _;
    }

    constructor(address _owner, string memory _tokenName, string memory _symbol, address _baseToken) ERC20(_tokenName, _symbol) {
        baseToken = _baseToken;
        owner = _owner;
    }

    function deposit(uint256 amount) external {
        ERC20(baseToken).safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function propose(address target, uint256 amount, string memory title, string memory description, uint256 deadline) external onlyOwner returns(uint256) {
        uint256 id = proposals.length;
        proposals.push(Proposal(target, amount, title, description, deadline));
        emit ProposalCreated(id, msg.sender, target, amount, title, description, deadline);
        return id;
    }


}
