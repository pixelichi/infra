#!/bin/bash

# Fetch the Vault server address from Helm release
VAULT_ADDRESS=$(helm get values vault -n vault | grep "serverUrl" | awk '{print $2}')

# Output the Vault address
echo "{\"vault_address\": \"$VAULT_ADDRESS\"}"
