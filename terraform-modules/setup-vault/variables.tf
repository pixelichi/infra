variable "service_account_name" {
  description = "Name of service account to give access to."
  type        = string
}

variable "namespace_name" {
  description = "Namespace in which the service account and setup will be done."
  type        = string
}

variable "backend_role_name" {
  description = "Name you want to give to the vault kubernetes auth backend role that allows reading of secrets"
  type        = string
}

variable "vault_policy_name" {

}

variable "vault_policy" {
  # policy = <<-EOT
  #   path "secret/data/terraform/minio" {
  #     capabilities = ["read"]
  #   }
  # EOT
  description = "Vault Policy that you with to embed onto your service account."
  type        = string
}
