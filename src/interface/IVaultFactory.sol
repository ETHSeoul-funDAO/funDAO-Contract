// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
interface IVaultFactory {

    event RaiseFund(
        uint256 id,
        address owner,
        string tokenName, 
        string symbol, 
        address baseToken, 
        uint256 fundingEnd
    );

    function raiseFund(
        address vault,
        address _owner,
        string memory _tokenName, 
        string memory _symbol, 
        address _baseToken, 
        uint256 _fundingEnd
    ) returns(Vault);

}
