// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VestingWallet} from "@openzeppelin/contracts/finance/VestingWallet.sol";

contract Vesting is VestingWallet {
    constructor(
        address beneficiary,
        uint64 startTimestamp,
        uint64 durationSeconds
    ) VestingWallet(beneficiary, startTimestamp, durationSeconds) {}
}
