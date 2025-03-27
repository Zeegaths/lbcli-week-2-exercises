# Created a SegWit address.
# Add funds to the address.
# Return only the Address
#!/bin/bash

# Create a SegWit address
SEGWIT_ADDRESS=$(bitcoin-cli -regtest -rpcwallet=btrustwallet getnewaddress "segwit_address" "bech32")

# Add some funds to the address (sending 1 BTC from wallet to this address)
bitcoin-cli -regtest sendtoaddress "$SEGWIT_ADDRESS" 1.0

# Return only the address
echo "$SEGWIT_ADDRESS"