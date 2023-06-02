// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault is ERC20 {

    using SafeERC20 for ERC20;

    address baseToken;

    constructor(string memory _tokenName, string memory _symbol, address _baseToken) ERC20(_tokenName, _symbol) {
        baseToken = _baseToken;
    }

    function deposit(uint256 amount) external {
        ERC20(baseToken).safeTransferFrom(msg.sender, address(this), amount);

    }
}
