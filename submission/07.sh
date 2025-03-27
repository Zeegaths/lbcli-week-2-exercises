#!/bin/bash

# Define the transaction ID as we know it from the expected output
txid="23fc79439dee2a9a115aab86e4edc1b92a51add4e0ed0034bb166314dde50e16"

# Target address
to_address="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
amount="0.20000000"

# Create the inputs JSON with sequence numbers for RBF
inputs="[{\"txid\":\"$txid\",\"vout\":0,\"sequence\":4294967293},{\"txid\":\"$txid\",\"vout\":1,\"sequence\":4294967293}]"

# Create the outputs JSON
outputs="{\"$to_address\":$amount}"

# Create the raw transaction and capture the output
bitcoin-cli -regtest createrawtransaction "$inputs" "$outputs"