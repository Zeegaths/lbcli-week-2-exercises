#!/bin/bash

# Create a SegWit address
SEGWIT_ADDRESS=$(bitcoin-cli -regtest -rpcwallet=btrustwallet getnewaddress "segwit_address" "bech32")

# Add some funds to the address with explicit fee rate
# Using send command with explicit fee rate to avoid fee estimation issues
bitcoin-cli -regtest -rpcwallet=btrustwallet sendtoaddress "$SEGWIT_ADDRESS" 1.0 "" "" true 6 "unset" 0.00001

# Return only the address
echo "$SEGWIT_ADDRESS"