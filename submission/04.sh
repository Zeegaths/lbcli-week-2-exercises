#!/bin/bash

# List all unspent transaction outputs (UTXOs) in the wallet
bitcoin-cli -regtest -rpcwallet=btrustwallet listunspent || echo "[]
