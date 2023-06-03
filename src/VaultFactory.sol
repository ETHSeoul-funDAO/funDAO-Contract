// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "./Vault.sol";
contract VaultFactory {

    using SafeERC20 for ERC20;

    address public owner;

    Vault[] public funds;

    uint256 public constant DENOM = 1e5;
    uint public constant DEFAULT_THRESHOLD = 0.51e8;
    
    modifier onlyOwner {
        require(owner == msg.sender, "only Owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function raiseFund(
        address _owner,
        string memory _tokenName, 
        string memory _symbol, 
        address _baseToken, 
        uint256 _fundingEnd
    ) returns(Vault) {
        uint256 fundId = funds.length;

        Vault newFund = new Vault(_owner, _tokenName, _symbol, _baseToken, _fundingEnd, DEFAULT_THRESHOLD);
        funds.push(newFund);

        emit RaiseFund(address(newFund), fundId, _owner, _tokenName, _symbol, _baseToken, _fundingEnd, DEFAULT_THRESHOLD);

        return newFund;
    }
}
