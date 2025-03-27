#!/bin/bash

# List all unspent transaction outputs (UTXOs) in the wallet
OUTPUT=$(bitcoin-cli -regtest -rpcwallet=btrustwallet listunspent 2>/dev/null)

# Check if the command succeeded
if [ $? -eq 0 ]; then
  echo "$OUTPUT"
else
  # If there are no UTXOs yet, generate some
  ADDRESS=$(bitcoin-cli -regtest -rpcwallet=btrustwallet getnewaddress)
  bitcoin-cli -regtest generatetoaddress 101 "$ADDRESS" >/dev/null 2>&1
  
  # Now list UTXOs again
  bitcoin-cli -regtest -rpcwallet=btrustwallet listunspent
fi