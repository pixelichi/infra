
resource "vault_kubernetes_auth_backend_role" "minio_secrets_read" {
  role_name                        = var.backend_role_name
  backend                          = var.kubernetes_backend
  bound_service_account_names      = ["${kubernetes_service_account.minio_sa.metadata[0].name}"]
  bound_service_account_namespaces = ["${kubernetes_service_account.minio_sa.metadata[0].namespace}"]
  token_policies                   = [vault_policy.read_minio_secrets.name]
  alias_name_source                = "serviceaccount_name"
  token_no_default_policy          = true
}

resource "vault_policy" "read_minio_secrets" {
  name   = "read-minio-secrets"
  policy = <<-EOT
    path "${var.vault_secrets_path}" {
      capabilities = ["read"]
    }
  EOT
}


