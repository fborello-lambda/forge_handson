// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vesting} from "../src/Vesting.sol";

contract VestingTest is Test {
    Vesting vesting;

    function setUp() public {
        vesting = new Vesting(msg.sender, 1, 2);
    }

    function test_vesting() public {
        assertEq(vesting.start(), 1);
        assertEq(vesting.duration(), 2);
        assertEq(vesting.end(), 3);
    }
}
