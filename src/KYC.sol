// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract KYC {

    mapping(address => bool) public verified;
    address public owner;
    
    modifier onlyOwner {
        require(owner == msg.sender, "only Owner");
        _;
    }

    constructor(address _owner){
        owner = _owner;
    }

    function approve(address user, bool verify) onlyOwner public{
        verified[user] = verify;
    }

    function isVerified(address user) view public returns (bool) {
        return verified[user];
    }

}
