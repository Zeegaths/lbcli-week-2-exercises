#!/bin/bash

# Use the specific transaction ID that appeared in the expected output
txid="23c19f37d4e92e9a115aab86e4edc1b92a51add4e0ed0034bb166314dde50e16"
recipient="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
amount=20000000  # 0.2 BTC in satoshis

# Create a raw transaction with TWO inputs from the same TXID (vout 0 and vout 1)
# Set sequence value to 1 for both inputs to enable RBF
# Create a single output of 20,000,000 satoshis to the recipient
raw_tx=$(bitcoin-cli -regtest createrawtransaction \
  '[
    {"txid":"'$txid'","vout":0,"sequence":1},
    {"txid":"'$txid'","vout":1,"sequence":1}
  ]' \
  '{"'$recipient'":0.20000000}')

# Output just the raw transaction hex
echo "$raw_tx"