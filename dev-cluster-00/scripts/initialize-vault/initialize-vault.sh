#!/bin/bash -e

SCRIPTS_DIR="$(pwd)/scripts"
RSC_DIR="$(pwd)/scripts/initialize-vault/rsc"

initialize_vault() {
  source "$SCRIPTS_DIR"/proxy-stop-vault/proxy-stop-vault.sh
  source "$SCRIPTS_DIR"/proxy-vault/proxy-vault.sh

  "$RSC_DIR"/init.sh
  "$RSC_DIR"/unseal.sh
  "$RSC_DIR"/create-terraform-policy.sh
  # $(MAKE) setup-vault-kubernetes-backend
}

initialize_vault
