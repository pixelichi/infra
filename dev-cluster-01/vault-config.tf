resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_mount" "kv" {
  path        = "secret"
  type        = "kv"
  description = "KV Secrets Engine"

  options = {
    version = "2" # Set to "1" for KV version 1
  }
}

resource "kubernetes_secret_v1" "vault_auth_sa_token" {
  metadata {
    name      = "vault-auth-sa-token"
    namespace = "vault"
    annotations = {
      "kubernetes.io/service-account.name" = "vault"
    }
  }
  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "vault_auth_secret" {
  metadata {
    name      = kubernetes_secret_v1.vault_auth_sa_token.metadata[0].name
    namespace = "vault"
  }
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://kubernetes.default.svc"
  kubernetes_ca_cert = var.k8s_cluster_ca_certificate
  token_reviewer_jwt = data.kubernetes_secret.vault_auth_secret.data.token
}
