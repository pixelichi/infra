#!/bin/bash

VAULT_ADDRESS='http://127.0.0.1:8200'

# Check if Vault is initialized
check_vault_initialized() {
  status=$(curl -s "${VAULT_ADDRESS}/v1/sys/init" | jq -r '.initialized')
  if [ "$status" = "true" ]; then
    return 0 # Vault is initialized
  else
    return 1 # Vault is not initialized
  fi
}

# Initialize Vault if not initialized
if check_vault_initialized; then
  printf "Vault is already initialized.\n\n"
else
  echo "Initializing Vault... Please save all tokens for future use!"
  vault operator init
  printf "\n\n"
fi
