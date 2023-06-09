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
        bool executed;
    }

    event Deposit(
        address user,
        uint256 amount
    );

    event Withdraw(
        address user,
        uint256 amount
    );

    event Distribute(
        address rewardToken,
        uint256 amount,
        uint256 rewardPerShare
    );

    event Claim(
        address user,
        uint256 amount
    );


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

    event ProposalExecuted(
        uint256 id,
        bool executed
    );

    event Vote(
        uint256 id,
        address user,
        uint256 amount
    );

    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function distribute(uint256 amount) external;
    function claim() external;
    function propose(address target, uint256 amount, string memory title, string memory description, uint256 deadline) external returns(uint256);
    function vote(uint256 id, uint256 amount) external;
    function execute(uint256 id) external;
    

}
