// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract Vault is ERC20 {

    constructor(string memory tokenName, string memory symbol) ERC20(tokenName, symbol) {

    }

    function deposit() external {

    }
}
