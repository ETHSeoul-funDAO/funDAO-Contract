// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/mock/MockBaseToken.sol";

contract VaultTest is Test {
    Vault public vault;
    MockBaseToken public mockBaseToken;

    address public user = address(0x123);
    address public owner = address(0x112233);

    uint256 public constant TEST_AMOUNT = 10_000 ether;
    uint256 public constant PROPOSE_AMOUNT = 100 ether;
    function setUp() public {
        mockBaseToken = new MockBaseToken();
        vault = new Vault(owner, "TestFund", "FUND", address(mockBaseToken), block.timestamp + 1 days, 0.5e5);
        mockBaseToken.mint(user, TEST_AMOUNT);
    }

    function testDeposit() public {
        vm.startPrank(user);
        mockBaseToken.approve(address(vault), TEST_AMOUNT);
        vault.deposit(TEST_AMOUNT);
        vm.stopPrank();
    }

    function testWithdraw() public {
        testDeposit();
        vm.startPrank(user);
        vault.withdraw(TEST_AMOUNT);
        vm.stopPrank();
    }

    function testPropose() public {
        vm.prank(owner);
        vault.propose(owner, PROPOSE_AMOUNT, "test", "hello", block.timestamp + 1 days);
    }

    function testVote() public {
        testDeposit();
        testPropose();
        vm.prank(user);
        vault.vote(0, TEST_AMOUNT);
    }

    function testExecute() public {
        testVote();
        skip(2 days);
        vm.prank(owner);
        vault.execute(0);
        assertEq(mockBaseToken.balanceOf(owner), PROPOSE_AMOUNT);
    }
}
