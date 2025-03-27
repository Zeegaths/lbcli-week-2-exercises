#!/bin/bash

# Use the specific transaction ID that appeared in the previous test
txid="23c19f37d4e92e9a115aab86e4edc1b92a51add4e0ed0034bb166314dde50e16"
recipient="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
amount=20000000  # 0.2 BTC in satoshis

# RBF is enabled by setting sequence to a value less than 0xFFFFFFFF-1
# We'll use 1 (the lowest possible value) to make it obvious this is RBF-enabled
rbf_sequence=1

# Create a simple raw transaction with RBF enabled
# - Using a single input (vout 0)
# - With RBF explicitly enabled via sequence number
# - Sending the exact amount to the recipient with no change
raw_tx=$(bitcoin-cli -regtest createrawtransaction \
  '[{"txid":"'$txid'","vout":0,"sequence":'$rbf_sequence'}]' \
  '{"'$recipient'":0.20000000}')

# Output just the raw transaction hex
echo "$raw_tx"