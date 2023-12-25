variable "service_account_name" {
  description = "Name of service account to give access to."
  type        = string
}

variable "namespace_name" {
  description = "Namespace in which the service account and setup will be done."
  type        = string
}

variable "role_name" {
  type        = string
  description = <<EOT
The role name you would like to use when tying your service account to the requested vault policy. 
You can call this module multiple times, with the smae role name to tie one service account to multiple policies.
  EOT 

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

