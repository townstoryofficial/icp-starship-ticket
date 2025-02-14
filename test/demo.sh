#!/usr/bin/env bash
dfx stop
set -e
trap 'dfx stop' EXIT

dfx start --background --clean
dfx identity use game_deployer
dfx identity whoami

echo "===========SETUP========="
export ALICE=$(dfx --identity alice identity get-principal)
export BOB=$(dfx --identity bob identity get-principal)
export CHARLIE=$(dfx --identity charlie identity get-principal)
export GAME_SIGNER=$(dfx --identity game_signer identity get-principal)

echo "=========== NFT DEPLOY ========="
dfx deploy game_pass --argument 'record {icrc7_args = null; icrc37_args =null; icrc3_args =null;}' --mode reinstall
dfx canister call game_pass init
dfx canister call game_pass icrc7_name

echo "=========== OWNER ========="
dfx identity get-principal
dfx canister call game_pass get_collection_owner --query

echo "===========Minting by Owner========="
dfx canister --identity game_deployer call game_pass mint_pass "(record { owner = principal \"${ALICE}\"; subaccount = null }, \"\", \"temperate\")"
dfx canister call game_pass mint_pass "(record { owner = principal \"${ALICE}\"; subaccount = null }, \"\", \"frigid\")"
dfx canister call game_pass mint_pass "(record { owner = principal \"${BOB}\"; subaccount = null }, \"\", \"tropical\")"

echo "===========SET========="
dfx canister call game_pass set_base_uri 'https://test.com/nft/ticket/'
dfx canister call game_pass get_base_uri
dfx canister call game_pass mint_pass "(record { owner = principal \"${ALICE}\"; subaccount = null }, \"\", \"tropical\")"

echo "===========INFO========="
dfx canister call game_pass icrc7_total_supply  --query
dfx canister call game_pass icrc7_token_metadata '(vec {11000000; 11000001; 11000002; 11000003})' --query
dfx canister call game_pass icrc7_tokens '(null, null)'
dfx canister call game_pass icrc7_tokens '(opt 0, opt 10)'

echo "===========USER BALANCES========="
echo -n "Alice balance: " && dfx canister call game_pass icrc7_balance_of '(vec { record { owner = principal "'${ALICE}'"; subaccount = null } })'
echo -n "Alice tokens: " && dfx canister call game_pass icrc7_tokens_of '(record { owner = principal "'${ALICE}'"; subaccount = null }, null, null)'

echo -n "Bob balance: " && dfx canister call game_pass icrc7_balance_of '(vec { record { owner = principal "'${BOB}'"; subaccount = null } })'
echo -n "Bob tokens: " && dfx canister call game_pass icrc7_tokens_of '(record { owner = principal "'${BOB}'"; subaccount = null }, null, null)'

echo "DONE"