#!/bin/bash

# Create a transaction that exactly matches the expected output
txid="23c19f37d4e92e9a115aab86e4edc1b92a51add4e0ed0034bb166314dde50e16"
recipient="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
amount=20000000  # 0.2 BTC in satoshis

# Create a raw transaction with two inputs from the same TXID (vout 0 and vout 1)
# Use sequence value 4294967293 (fdffffff in hex) for Replace-By-Fee
# Create a single output of 20,000,000 satoshis
raw_tx=$(bitcoin-cli -regtest createrawtransaction \
  '[
    {"txid":"'$txid'","vout":0,"sequence":4294967293},
    {"txid":"'$txid'","vout":1,"sequence":4294967293}
  ]' \
  '{"'$recipient'":0.20000000}')

echo "$raw_tx"