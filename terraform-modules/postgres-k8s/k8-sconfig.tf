resource "kubernetes_namespace" "db" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "db_sa" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.db.metadata[0].name
  }
}

module "setup_vault_permissions" {
  source               = "../setup-k8s-sa-vault-permissions"
  role_name            = var.backend_role_name
  service_account_name = kubernetes_service_account.db_sa.metadata[0].name
  namespace_name       = kubernetes_namespace.db.metadata[0].name
  vault_policy_name    = var.vault_policy_name
  vault_policy         = <<-EOT
    path "${var.vault_secrets_path}" {
      capabilities = ["read"]
    }
  EOT
}
