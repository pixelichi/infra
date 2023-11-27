locals {
  vault_policy_prefix = "terraform"
  vault_secret_prefix = "secret/terraform"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_mount" "kv" {
  path        = "secret"
  type        = "kv"
  description = "KV Secrets Engine"

  options = {
    version = "2"  # Set to "1" for KV version 1
  }
}