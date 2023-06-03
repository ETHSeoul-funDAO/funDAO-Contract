// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/mock/MockBaseToken.sol";

contract VaultTest is Test {
    Vault public vault;
    MockBaseToken public mockBaseToken;

    address user = address(0x123);
    address owner = address(0x112233);

    uint256 constant TEST_AMOUNT = 10_000 ether;
    function setUp() public {
        mockBaseToken = new MockBaseToken();
        vault = new Vault(owner, "TestFund", "FUND", address(mockBaseToken));
        mockBaseToken.mint(user, TEST_AMOUNT);
    }

    function testDeposit() public {
        vm.startPrank(user);
        mockBaseToken.approve(address(vault), TEST_AMOUNT);
        vault.deposit(TEST_AMOUNT);
        vm.stopPrank();
    }

    function testPropose() public {
        vm.prank(owner);
        vault.propose(owner, 1e18, "test", "hello", block.timestamp);
    }
}
