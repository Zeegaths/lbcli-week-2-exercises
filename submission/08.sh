#!/bin/bash

# The raw transaction hex to get UTXOs from
raw_tx="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"

# Decode the transaction to get the transaction ID
txid=$(bitcoin-cli -regtest decoderawtransaction "$raw_tx" | jq -r '.txid')

# Target address and amount
to_address="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"
amount_satoshis=20000000
amount_btc=$(echo "scale=8; $amount_satoshis / 100000000" | bc)

# Get the total input amount from the previous transaction outputs
input_satoshis=$(bitcoin-cli -regtest decoderawtransaction "$raw_tx" | jq '[.vout[].value] | map(. * 100000000) | add | floor')
fee_satoshis=1000  # Initial low fee of 1000 satoshis
change_satoshis=$((input_satoshis - amount_satoshis - fee_satoshis))
change_btc=$(echo "scale=8; $change_satoshis / 100000000" | bc)

# Create a JSON inputs array with sequence number set to 1 for RBF
# Setting sequence to 1 signals opt-in RBF as per BIP 125
inputs='['
inputs+='{"txid":"'$txid'","vout":0,"sequence":1},'  # Set sequence to 1 for RBF
inputs+='{"txid":"'$txid'","vout":1,"sequence":1}'   # Set sequence to 1 for RBF
inputs+=']'

# Create outputs with the target address and change address
outputs='{'
outputs+='"'$to_address'":'$amount_btc
if [ $change_satoshis -gt 0 ]; then
  # Use the same address for change in this example
  outputs+=',"'$to_address'":'$change_btc
fi
outputs+='}'

# Create the raw transaction
new_raw_tx=$(bitcoin-cli -regtest createrawtransaction "$inputs" "$outputs")

echo "RBF-enabled transaction (can be fee-bumped later):"
echo "$new_raw_tx"

echo ""
echo "To use this transaction:"
echo "1. Sign it: bitcoin-cli -regtest signrawtransactionwithwallet \"$new_raw_tx\""
echo "2. Get the signed hex: | jq -r '.hex'"
echo "3. Send it: bitcoin-cli -regtest sendrawtransaction <signed_hex>"
echo ""
echo "To bump the fee later:"
echo "Method 1 (automatic): bitcoin-cli -regtest bumpfee <txid>"
echo "Method 2 (manual): Create a new transaction with the same inputs but higher fee"