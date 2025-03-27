#!/bin/bash

# First, check if there are any UTXOs
current_utxos=$(bitcoin-cli -regtest listunspent)

# Check if we already have UTXOs with txid
if [[ "$current_utxos" != "[]" && "$current_utxos" =~ "txid" ]]; then
  echo "$current_utxos"
  exit 0
fi

# If no UTXOs, generate an address and mine some blocks
address=$(bitcoin-cli -regtest getnewaddress)
bitcoin-cli -regtest generatetoaddress 101 "$address" >/dev/null 2>&1

# Now list UTXOs (should include coinbase transactions)
bitcoin-cli -regtest listunspent