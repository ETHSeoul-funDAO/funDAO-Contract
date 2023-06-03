// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IVaultFactory {

    event RaiseFund(
        address vault,
        uint256 id,
        address owner,
        string tokenName, 
        string symbol, 
        address baseToken, 
        uint256 fundingEnd,
        uint256 threshold
    );

    function raiseFund(
        address _owner,
        string memory _tokenName, 
        string memory _symbol, 
        address _baseToken, 
        address _rewardToken,
        uint256 _fundingEnd
    ) external returns(address);

}
