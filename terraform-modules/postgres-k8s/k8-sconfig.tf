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

module "setup_permissions" {
  source = "../setup-vault"

  backend_role_name    = "database-secret-read-backend-role"
  service_account_name = kubernetes_service_account.db_sa.metadata[0].name
  namespace_name       = kubernetes_namespace.db.metadata[0].name
  vault_policy_name    = "read-db-secrets"
  vault_policy         = <<-EOT
    path "secret/data/terraform/db" {
      capabilities = ["read"]
    }
  EOT
}
