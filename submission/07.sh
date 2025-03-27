#!/bin/bash

# Raw transaction to analyze
raw_tx="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"

# Destination address
recipient="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"

# Amount to send in satoshis
amount_satoshis=20000000

# Step 1: Decode the raw transaction to get its TXID
txid=$(bitcoin-cli -regtest decoderawtransaction "$raw_tx" | jq -r '.txid')
echo "Transaction ID: $txid"

# Step 2: Analyze the UTXOs in the transaction
decoded_tx=$(bitcoin-cli -regtest decoderawtransaction "$raw_tx")
vout0_value=$(echo "$decoded_tx" | jq -r '.vout[0].value * 100000000 | floor')
echo "UTXO 0 value: $vout0_value satoshis"

# For this transaction, we'll use vout 0
utxo_vout=0
utxo_value=$vout0_value

# Step 3: Calculate a reasonable fee
fee_satoshis=1400  # Assuming transaction size ~140 bytes at 10 sat/byte

# Calculate change amount
change_satoshis=$((utxo_value - amount_satoshis - fee_satoshis))
echo "Fee: $fee_satoshis satoshis"
echo "Change: $change_satoshis satoshis"

# Check if we have enough funds
if [ "$change_satoshis" -lt 0 ]; then
    echo "Error: Insufficient funds in the selected UTXO"
    exit 1
fi

# Step 4: Convert satoshis to BTC for the raw transaction
amount_btc=$(printf "%.8f" $(echo "scale=8; $amount_satoshis/100000000" | bc))
change_btc=$(printf "%.8f" $(echo "scale=8; $change_satoshis/100000000" | bc))

# Change address 
change_address="bcrt1qg09ftw43jvlhj4wlwwhkxccjzmda3kdm4y83ht"

# Step 5: Create the raw transaction
echo "Creating raw transaction..."
raw_tx_hex=$(bitcoin-cli -regtest createrawtransaction \
    '[{"txid":"'$txid'","vout":'$utxo_vout'}]' \
    '{"'$recipient'":'$amount_btc',"'$change_address'":'$change_btc'}')

echo "Raw Transaction: $raw_tx_hex"

# Output the raw transaction hex as the final result 
# (this makes it easy to capture for further processing)
echo $raw_tx_hex