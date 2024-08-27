<h1 align="center">Foundry/Tokenomics Demo</h1>

# Before We Start

Using:
- [slides](https://github.com/maaslalani/slides?tab=readme-ov-file)
  - `forge` commands don't show the output well.
    - `jq` commands combined with `sponge` are used to output the contract addresses to the screen and changing the `.envrc` file.
  - Use `Ctrl-E` to run the `bash` snippets.
  - `slides README.md` to run the slides in the terminal.
- [direnv](https://direnv.net/)
  - `direnv allow` or `direnv reload` doesn't work directly when running `slides`.

---

# Some Theory

## Vesting

- Gradual Token Release: Tokens are released over time, not all at once.
|
|
- Encourages Long-Term Commitment: Stakeholders are motivated to stay with the project.
|
|
- Reduces Market Risks: Prevents sudden sell-offs that can destabilize prices.
|
|
- Builds Credibility: Shows transparency, attracting more investors and partners.
|
|
- Flexible Schedules: Can include linear vesting or cliff vesting options. `Tokenomics`
  - Useful WebPage [WLD - Unlock Schedule & Tokenomics](https://token.unlocks.app/worldcoin-wld)

## Multi Sig Account

- Multi Sig wallets are `contracts`.
|
|
- We have `N` owners.
|
|
- Each owner can create transactions
  - to execute them `M` owners have to "sign" it.


---

### Pros

- Shared Responsibility
|
- Adaptable to Team Structures
|
- Risk Mitigation
  - Reduced Risk of Human Error
  - Protection Against Threats:


### Cons

- Unavailability of Signers
|
- Multiple Points of Attack
|
- Hard to Manage
|
- Complexity in Interacting with Smart Contracts
  - Difficulty in Executing Transactions

---

## Safe

There are two `easy` ways to deploy a multi-signature wallet.
The `hard` way involves directly interacting with the contracts.

### Safe CLI

Using Safe's CLI:

```bash
docker run -it safeglobal/safe-cli safe-creator \
https://ethereum-sepolia-rpc.publicnode.com \
$DEPLOYER_PRIVATE_KEY \
--threshold 1 \
--owners $DEPLOYER_ADDRESS
```

NOTE: It's interactive.

### Safe Wallet APP

Using the web app:

[Safe{Wallet} – Welcome](https://app.safe.global/welcome)

---

# Demo FlowChart

>1. [Create Safe Wallet]

>2. [Create ERC20] -> [Mint to Safe Wallet]

>3. [Create Vesting Wallet]

>4. [Propose multisig TX sending some ERC20]
> from `SAFE_WALLET` to `VESTING_WALLET`

>5. [Release ERC20]


---

# Vesting and Token Demo

## Use the .envrc.example as template

```bash
cp .envrc.example .envrc
```

## Initial SetUp

Set the env variables in the `.envrc` file:
- `DEPLOYER_PRIVATE_KEY`
- `DEPLOYER_ADDRESS`
- `SEPOLIA_URL`


## Set the Initial Supply for the ERC20

Set the env variable in the `.envrc` file:
- `INITIAL_SUPPLY`

---

## Apply the .envrc file

```bash
direnv allow
```

If changes are made, the variables have to be reloaded:

```bash
direnv reload
```

NOTE: If running it as a `slide`, you have to close and reopen the slide after running the command.

---

## Deploy the ERC20 Token

### Forge Script to Deploy
```bash
forge script script/Deploy.s.sol:DeployToken --rpc-url $SEPOLIA_URL --broadcast
```

### Print the Contract Address

```bash
jq '.transactions[0].contractAddress' broadcast/Deploy.s.sol/11155111/run-latest.json | awk '{print "Contract Address: \033[0;32m" $0 "\033[0m"}'
```

### Modify the .envrc file automatically

Use the output to set `ERC20_CONTRACT_ADDRESS` in the `.envrc`.
The following command does this automatically:

```bash
awk -v new_value="$(jq -r '.transactions[0].contractAddress' broadcast/Deploy.s.sol/11155111/run-latest.json)" '/^export ERC20_CONTRACT_ADDRESS=/ {print "export ERC20_CONTRACT_ADDRESS=" new_value; next} 1' .envrc.example \
| sponge .envrc.example
```

---

## Deploy the Vesting Wallet

### Forge Script to Deploy

```bash
START_TIME=$(date +%s) forge script script/Deploy.s.sol:DeployVesting --rpc-url $SEPOLIA_URL --broadcast
```

### Print the Contract Address

```bash
jq '.transactions[0].contractAddress' broadcast/Deploy.s.sol/11155111/run-latest.json | awk '{print "Contract Address: \033[0;32m" $0 "\033[0m"}'
```

### Modify the .envrc file automatically

Use the output to set the `VESTING_CONTRACT_ADDRESS` in the `.envrc`.
The following command does this automatically:

```bash
awk -v new_value="$(jq -r '.transactions[0].contractAddress' broadcast/Deploy.s.sol/11155111/run-latest.json)" '/^export VESTING_CONTRACT_ADDRESS=/ {print "export VESTING_CONTRACT_ADDRESS=" new_value; next} 1' .envrc.example \
| sponge .envrc.example
```

---

## Check if the token can be released
```bash
cast call $VESTING_CONTRACT_ADDRESS "releasable(address)(uint256)" $ERC20_CONTRACT_ADDRESS --rpc-url $SEPOLIA_URL
```


## Check balance
```bash
cast balance --erc20 $ERC20_CONTRACT_ADDRESS $BENEFICIARY_ADDRESS --rpc-url $SEPOLIA_URL
```

---

## Release the tokens
```bash
cast send $VESTING_CONTRACT_ADDRESS "release(address)" $ERC20_CONTRACT_ADDRESS --rpc-url $SEPOLIA_URL --private-key $BENEFICIARY_PRIVATE_KEY
```

## Check balance
```bash
cast balance --erc20 $ERC20_CONTRACT_ADDRESS $BENEFICIARY_ADDRESS --rpc-url $SEPOLIA_URL
```
