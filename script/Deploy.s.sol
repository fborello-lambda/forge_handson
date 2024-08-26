// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {Token} from "../src/Token.sol";
import {Vesting} from "../src/Vesting.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

contract DeploySafeAll is Script {
    uint256 deployerPrivateKey;
    address safeWalletAddress;
    address beneficiaryAddress;
    uint64 start;
    uint64 duration;

    function setUp() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        safeWalletAddress = vm.envAddress("ADDRESS_SAFE");
        beneficiaryAddress = vm.envAddress("ADDRESS_BENEFICIARY");
        start = uint64(vm.envUint("START_TIME"));
        duration = uint64(vm.envUint("DURATION"));
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        Vesting vesting = new Vesting(beneficiaryAddress, start, duration);

        Token token = new Token(address(safeWalletAddress), 1000000);

        console.logUint(token.balanceOf(safeWalletAddress));

        vm.stopBroadcast();
    }
}

contract DeployVesting is Script {
    uint256 deployerPrivateKey;
    address beneficiaryAddress;
    uint64 start;
    uint64 duration;

    function setUp() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        beneficiaryAddress = vm.envAddress("ADDRESS_BENEFICIARY");
        start = uint64(vm.envUint("START_TIME"));
        duration = uint64(vm.envUint("DURATION"));
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        Vesting vesting = new Vesting(beneficiaryAddress, start, duration);

        vm.stopBroadcast();
    }
}

contract DeployToken is Script {
    uint256 deployerPrivateKey;
    address safeWalletAddress;

    function setUp() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        safeWalletAddress = vm.envAddress("ADDRESS_SAFE");
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        Token token = new Token(address(safeWalletAddress), 1000000);

        console.logUint(token.balanceOf(safeWalletAddress));

        vm.stopBroadcast();
    }
}
