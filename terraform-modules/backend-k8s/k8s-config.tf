
resource "kubernetes_namespace" "backend" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "backend" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.backend.metadata[0].name
  }
}

locals {
  vault_role_name = "read-secrets-role-backend"
}

module "secrets_role" {
  source               = "../setup-k8s-sa-vault-permissions"
  role_name            = local.vault_role_name
  service_account_name = kubernetes_service_account.backend.metadata[0].name
  namespace_name       = kubernetes_namespace.backend.metadata[0].name
  vault_policy_name    = "read-db-minio-secrets-for-backend"
  vault_policy         = <<-EOT
    path "${var.db_secret_path}" {
      capabilities = ["read"]
    }

    path "${var.minio_secret_path}" {
      capabilities = ["read"]
    }

    path "${var.backend_secret_path}" {
      capabilities = ["read"]
    }
  EOT
}
