#!/bin/sh

# Get the bytecode of the contract
BYTECODE=$(forge inspect $CONTRACT bytecode)

CALLDATA=$BYTECODE

# Output the final calldata
echo $CALLDATA
