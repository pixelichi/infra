output "vault_secret_role" {
  description = "The role to use when fetching secrets from pod deployment"
  value       = vault_kubernetes_auth_backend_role.auth_backend_role.role_name
}
