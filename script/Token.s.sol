// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/Token.sol";

contract TokenScript is Script {
    uint256 deployerPrivateKey;
    function setUp() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        Token token = new Token(1000000);

        vm.stopBroadcast();
    }
}
