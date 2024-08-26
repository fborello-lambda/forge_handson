Inside the `.env`:

```
PRIVATE_SAFE=<DEPLOYER PK>
ADDRESS_SAFE=<OWNER1 ADDR>
```

```sh
source .env
docker run -it safeglobal/safe-cli safe-creator \
        https://ethereum-sepolia-rpc.publicnode.com \
        $PRIVATE_SAFE \
        --threshold 1 \
        --owners $ADDRESS_SAFE
```

Paste the safe wallet contract address in the `.env` file:

```
SAFE_WALLET=<SAFE WALLET CONTRACT ADDRESS>
```

To deploy the contracts:
```sh
START_TIME=$(date +%s) DURATION=100 forge script script/Deploy.s.sol:Deploy --rpc-url <rpc_url> --broadcast
```
