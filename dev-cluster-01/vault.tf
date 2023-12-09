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

resource "kubernetes_service_account" "vault_auth" {
  metadata {
    name      = "vault-auth"
    namespace = "default"
  }
}


resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = "role-tokenreview-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.vault_auth.metadata[0].name
    namespace = "default"
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
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.HOST
  kubernetes_ca_cert     = var.CLUSTER_CA_CERTIFICATE
  token_reviewer_jwt     = data.kubernetes_secret.vault_auth_secret.data.token
  disable_local_ca_jwt   = true
  disable_iss_validation = true

}
