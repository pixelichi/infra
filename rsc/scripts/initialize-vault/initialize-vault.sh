#!/bin/bash -e

VAULT_RSC_DIR="../rsc/scripts/initialize-vault/rsc"

check_vault_installed() {
  if ! command -v vault &>/dev/null; then
    printf "\e[31m%s\e[0m\n" "Vault CLI tool is not installed. Follow instructions here https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install to install before calling this script."
    exit 1
  else
    echo "Vault CLI tool is installed."
  fi
}

initialize_vault() {
  source ../rsc/scripts/k8s/port-forward.sh "vault" "vault" 8200 8200
  source ../rsc/scripts/k8s/port-forward.sh "vault" "vault" 8201 8201

  "$VAULT_RSC_DIR"/init.sh
  "$VAULT_RSC_DIR"/unseal.sh
  "$VAULT_RSC_DIR"/create-terraform-policy.sh
}

check_vault_installed
initialize_vault
