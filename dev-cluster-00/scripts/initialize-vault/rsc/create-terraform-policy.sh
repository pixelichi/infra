#!/bin/bash

# Vault Address
export VAULT_ADDR="http://127.0.0.1:8200"

POLICY_FILE="$(pwd)/scripts/initialize-vault/rsc/terraform-policy.hcl"

# Policy Name
POLICY_NAME="terraform"

# Policy Definition

# Function to check if user is logged into Vault
check_vault_login() {
  vault token lookup >/dev/null 2>&1
  return $?
}

# Function to check if the policy already exists
check_policy_exists() {
  vault policy list | grep -qw $POLICY_NAME
  return $?
}

# Ensure the user is logged in
if ! check_vault_login; then
  echo "You are not logged in to Vault. Please log in with a user who can create the policy for terraform."
  vault login
  if [ $? -ne 0 ]; then
    echo "Vault login failed. Exiting."
    exit 1
  fi
fi

echo "Creating policy '$POLICY_NAME' or updating if already existant..."
vault policy write $POLICY_NAME $POLICY_FILE
if [ $? -eq 0 ]; then
  echo "Policy '$POLICY_NAME' created successfully."
else
  echo "Failed to create policy '$POLICY_NAME'."
fi
