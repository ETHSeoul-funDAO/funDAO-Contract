// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IVault {

    struct Proposal {
        address target;
        uint256 amount; 
        string title;
        string description;
        uint256 deadline;
        uint256 targetVote;
    }

    event ProposalCreated(
        uint256 id,
        address proposer,
        address target,
        uint256 amount,
        string title,
        string description,
        uint256 deadline,
        uint256 targetVote
    );

    event Vote(
        uint256 id,
        address user,
        uint256 amount
    );
    function deposit(uint256 amount) external;

    function propose(address target, uint256 amount, string memory title, string memory description, uint256 deadline) external returns(uint256);

}
