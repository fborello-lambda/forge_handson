// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor(
        address owner,
        address vestingAddress,
        uint256 initialSupply
    ) ERC20("Token", "TKN") Ownable(owner) {
        // The beneficiary will have all the initialSupply
        _mint(vestingAddress, initialSupply);
    }
}
