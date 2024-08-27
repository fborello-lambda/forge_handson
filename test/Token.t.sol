// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token token;

    function setUp() public {
        vm.prank(msg.sender);
        token = new Token(msg.sender, 3737);
    }

    function test_token() public {
        assertEq(token.balanceOf(msg.sender), 3737);
    }
}
