#!/bin/bash

# Generate a new bech32 address for the regtest network
change_address=$(bitcoin-cli -regtest getnewaddress "" "bech32")

# Print only the address
echo "$change_address"