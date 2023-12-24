
resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "minio_sa" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.minio.metadata[0].name
  }
}

module "setup_vault_service_account_permissions" {
  source               = "../setup-k8s-sa-vault-permissions"
  backend_role_name    = var.backend_role_name
  namespace_name       = kubernetes_namespace.minio.metadata[0].name
  service_account_name = kubernetes_service_account.minio_sa.metadata[0].name
  vault_policy_name    = var.vault_policy_name
  vault_policy         = <<-EOT
    path "${var.vault_secrets_path}" {
      capabilities = ["read"]
    }
  EOT
}
