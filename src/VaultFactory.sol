// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Vault.sol";
import "./interface/IVaultFactory.sol";

contract VaultFactory is IVaultFactory {

    address public owner;
    address public kyc;

    Vault[] public funds;

    uint256 public constant DENOM = 1e5;
    uint public constant DEFAULT_THRESHOLD = 0.5e18;

    modifier onlyOwner {
        require(owner == msg.sender, "only Owner");
        _;
    }

    constructor(address _owner, address _kyc) {
        owner = _owner;
        kyc = _kyc;
    }

    function raiseFund(
        address _owner,
        string memory _tokenName, 
        string memory _symbol, 
        address _baseToken,
        address _rewardToken, 
        uint256 _fundingEnd
    ) external returns(address) {
        uint256 fundId = funds.length;

        Vault newFund = new Vault(_owner, _tokenName, _symbol, _baseToken, _rewardToken, kyc, _fundingEnd, DEFAULT_THRESHOLD);
        funds.push(newFund);

        emit RaiseFund(address(newFund), fundId, _owner, _tokenName, _symbol, _baseToken, _fundingEnd, DEFAULT_THRESHOLD);

        return address(newFund);
    }
}
