// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {Token} from "../src/Token.sol";
import {Vesting} from "../src/Vesting.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

contract Deploy is Script {
    uint256 deployerPrivateKey;
    address safeWalletAddress = vm.envAddress("ADDRESS_SAFE");
    uint64 start = uint64(vm.envUint("START_TIME"));
    uint64 duration = uint64(vm.envUint("DURATION"));
    function setUp() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        Vesting vesting = new Vesting(safeWalletAddress, start, duration);

        Token token = new Token(address(vesting), safeWalletAddress, 1000000);

        console.logUint(token.balanceOf(safeWalletAddress));

        vm.stopBroadcast();
    }
}
