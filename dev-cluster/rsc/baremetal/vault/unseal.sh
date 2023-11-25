#!/bin/bash

# Define the Vault address (change this to your Vault's address)
VAULT_ADDRESS="http://127.0.0.1:8200"

# Function to check seal status
check_vault_seal_status() {
  seal_status=$(vault status -format=json | jq '.sealed')
  if [ "$seal_status" = "true" ]; then
    return 1 # Vault is sealed
  else
    return 0 # Vault is unsealed
  fi
}

# Check if Vault is sealed
if check_vault_seal_status; then
  echo "Vault is already unsealed."
else
  echo "Vault is sealed. Starting the unseal process..."
  total_keys=$(vault status -format=json | jq '.t')
  unseal_count=0

  # Unseal loop
  while [ $unseal_count -lt $total_keys ]; do
    read -sp "Enter unseal key $((unseal_count + 1)) of $total_keys: " unseal_key
    echo ""
    vault operator unseal $unseal_key

    if check_vault_seal_status; then
      echo "Vault is unsealed successfully."
      break
    fi
    ((unseal_count++))
  done
fi
