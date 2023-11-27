#!/bin/bash -e

SCRIPTS_DIR="$(pwd)/scripts"
RSC_DIR="$(pwd)/scripts/initialize-vault/rsc"

initialize_vault() {
  source "$SCRIPTS_DIR"/port-forward.sh "vault" "vault" 8200 8200
  source "$SCRIPTS_DIR"/port-forward.sh "vault" "vault" 8201 8201

  "$RSC_DIR"/init.sh
  "$RSC_DIR"/unseal.sh
  "$RSC_DIR"/create-terraform-policy.sh
}

initialize_vault
