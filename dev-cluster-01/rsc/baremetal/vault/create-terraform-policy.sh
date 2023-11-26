#!/bin/bash

# Vault Address
VAULT_ADDRESS="http://127.0.0.1:8200"

# Policy Name
POLICY_NAME="terraform-policy"

# Policy Definition
POLICY_CONTENT='
path "secret/terraform/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Enable the Kubernetes auth backend
path "sys/auth/kubernetes" {
  capabilities = ["create", "read", "update", "delete"]
}

# Configure the Kubernetes auth backend
path "auth/kubernetes/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Optional: Permissions to manage policies, roles, etc.
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["update"]
}
'

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
  echo "You are not logged in to Vault. Please log in."
  vault login
  if [ $? -ne 0 ]; then
    echo "Vault login failed. Exiting."
    exit 1
  fi
fi

# Check if policy exists and create it if it doesn't
if check_policy_exists; then
  printf "Policy '%s' already exists.\n\n" "$POLICY_NAME"
else
  echo "Creating policy '$POLICY_NAME'..."
  echo "$POLICY_CONTENT" | vault policy write $POLICY_NAME -
  if [ $? -eq 0 ]; then
    echo "Policy '$POLICY_NAME' created successfully."
  else
    echo "Failed to create policy '$POLICY_NAME'."
  fi
fi
