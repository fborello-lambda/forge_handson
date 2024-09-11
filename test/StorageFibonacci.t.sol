// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StorageFibonacci} from "../src/StorageFibonacci.sol";

contract StorageFibonacciTest is Test {
    StorageFibonacci sto;

    function setUp() public {
        sto = new StorageFibonacci();
    }

    function test_storage_is_zero() view public {
        assertEq(sto.get(), 0);
    }

    function test_set() public {
        // fibonacci(11) == 89
        sto.set(11);
        assertEq(sto.get(), 89);
    }
}
