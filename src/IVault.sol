// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IVault {

    struct Proposal {
        address target;
        uint256 amount; 
        string title;
        string description;
        uint256 deadline;
    }

    event ProposalCreated(
        uint256 id,
        address proposer,
        address target,
        uint256 amount,
        string title,
        string description,
        uint256 deadline
    );

    function deposit(uint256 amount) external;

    function propose(address target, uint256 amount, string memory title, string memory description, uint256 deadline) external returns(uint256);

}
