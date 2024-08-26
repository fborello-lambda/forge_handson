// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vesting} from "../src/Vesting.sol";
import {Token} from "../src/Token.sol";

contract VestingAndTokenTest is Test {
    Vesting vesting;
    Token token;

    function setUp() public {
        vesting = new Vesting(msg.sender, 0, 0);
        token = new Token(address(vesting), 3737);
    }

    function test_vestingAndToken() public {
        // Initially the vesting address should have all the tokens.
        assertEq(token.balanceOf(address(vesting)), 3737);
        assertEq(token.balanceOf(msg.sender), 0);
        vesting.release(address(token));
        // Then, the tokens are released and the tokens are transferred to the beneficiary.
        assertEq(token.balanceOf(address(vesting)), 0);
        assertEq(token.balanceOf(msg.sender), 3737);
    }
}
