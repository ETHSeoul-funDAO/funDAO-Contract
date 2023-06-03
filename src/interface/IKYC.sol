// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface KYC {

    function isVerified(address user) view external returns (bool);

}
