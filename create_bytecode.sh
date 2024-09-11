#!/bin/sh

# Get the bytecode of the contract
BYTECODE=$(forge inspect $CONTRACT bytecode)

# Get the types of the constructor arguments
TYPES=$(forge inspect $CONTRACT abi | jq -r '.[] | select(.type == "constructor") | .inputs | map(.type) | join(",")')

# Replace `constructor($TYPES)` with the actual constructor signature
# Make sure to provide the actual arguments in the correct format
# For example, if the constructor takes an address and a uint256, you might do:
# Replace <address> and <value> with actual values
ARGS=$(cast abi-encode "constructor($TYPES)" $CONSTRUCTOR_ARGS)

# Concatenate the bytecode and the encoded arguments
CALLDATA=$(cast --concat-hex "$BYTECODE" "$ARGS")

# Output the final calldata
echo $CALLDATA
