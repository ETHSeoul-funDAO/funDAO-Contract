// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract MockBaseToken is ERC20 {

    constructor() ERC20("Mock Base Token", "MOCK") {
    }

    function mint(address user, uint256 amount) public {
        _mint(user, amount);
    }
}
