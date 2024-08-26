<h1 align="center">Foundry HandsOn</h1>

```sh
forge init <Project's name>
```

```sh
cd <Project's name>
```

Install `openzeppelin-contracts`:

```sh
forge install OpenZeppelin/openzeppelin-contracts
echo "@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/" >> remmapings.txt
```

The project's structure should be:

```
.
├── README.md
├── foundry.toml
├── lib
│   ├── forge-std
│   └── openzeppelin-contracts
├── remmapings.txt
├── script
│   └── Counter.s.sol
├── src
│   └── Counter.sol
└── test
    └── Counter.t.sol
```

We can replace all the occurrences of `Counter` to `Token` i.e:

```
.
├── README.md
├── foundry.toml
├── lib
│   ├── forge-std
│   └── openzeppelin-contracts
├── remmapings.txt
├── script
│   └── Token.s.sol
├── src
│   └── Token.sol
└── test
    └── Token.t.sol
```

Then, inside `Token.sol`, which is the main contract, the example from the [OZ docs'](https://docs.openzeppelin.com/contracts/4.x/erc20#constructing-an-erc20-token-contract) can be used:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 initialSupply) ERC20("Token", "TKN") {
        // The deployer will have all the initialSupply
        _mint(msg.sender, initialSupply);
    }
}
```

Then we have to change the deployment script `script/Token.s.sol`:

- Reference: [Solidity Scripting - Foundry Book](https://book.getfoundry.sh/tutorials/solidity-scripting)


```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/Token.sol";

contract TokenScript is Script {
    uint256 deployerPrivateKey;
    function setUp() public {
        // foundry will read the env variable named PRIVATE_KEY
        // and it will use it to deploy the contract
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    }

    function run() public {
        vm.startBroadcast(deployerPrivateKey);

        // This is the initialSupply the constructor will use
        Token token = new Token(1000000);

        vm.stopBroadcast();
    }
}
```

For simplicity, the contract will be deployed in a local environment created with `anvil`.
Run `anvil` in a terminal, the output should be:

```
Available Accounts
==================

(0) 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000.000000000000000000 ETH)
.
.

Private Keys
==================

(0) 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
.
.
```

This funded account can be used to deploy the contract, with `anvil` running, open a new terminal and run:

```sh
echo "PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" > .env
echo "ADDRESS=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" >> .env
```

Then, deploy the contract, `forge` will automatically read the `.env` file:

```sh
forge script script/Token.s.sol:TokenScript --rpc-url http:localhost:8545 --broadcast
```

Finally, the output should contain the `Contract Address`:

```shell
✅  [Success]Hash: 0x07ba8c8365d97fa68eef4d623fe5c1a91b7318dee6071b3c4e0de3b8a8e6551b
Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Block: 1
Paid: 0.002214764 ETH (553691 gas * 4 gwei)
```

It can be used with `cast` to ask for the erc20 `balance`, the constructor of the Contract was defined to mint the `initialSupply` to the `deployer` address, and the `initialSupply` was defined in the `Token.s.sol`: `Token token = new Token(1000000);`:

```sh
source .env
cast balance --erc20 0x5FbDB2315678afecb367f032d93F642f64180aa3 $ADDRESS --rpc-url http:localhost:8546
```

Output:

```
1000000 [1e6]
```

# References

[solidity - Foundry scripts read deployed contract addresses - Ethereum Stack Exchange](https://ethereum.stackexchange.com/questions/162092/foundry-scripts-read-deployed-contract-addresses)
