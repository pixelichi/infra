# Fields with defaults ===================================================================================

variable "service_account_name" {
  description = "Service Account with this name will be created to deploy postgress."
  type        = string
  default     = "db-sa"
}

variable "namespace" {
  description = "Namespace that will be created to deploy postgres."
  type        = string
  default     = "db"
}

variable "STORAGE_CLASS" {
  # Unsure why this works...but for some reason we need to set this in order for the pv and pvc to match up
  default = "manual"
}

variable "host_data_path" {
  description = "Path on the host node that should be used to store data."
  type        = string
  default     = "/mnt/db"
}

variable "use_load_balancer" {
  description = "Set to true to use LoadBalancer, false to use NodePort"
  type        = bool
  default     = false
}

variable "db_name" {
  type        = string
  description = "value"
  default     = "db"
}


variable "backend_role_name" {
  description = "vault_kubernetes_auth_backend_role name"
  type        = string
  default     = "database-secret-read-backend-role"
}

variable "vault_policy_name" {
  description = "The name of the vault policy which will be used to store secrets that the deployment pods can access."
  type        = string
  default     = "read-db-secrets"
}

variable "vault_secrets_path" {
  description = "Location of where the secrets for the deployment pods are stored."
  type        = string
  default     = "secret/data/terraform/db"
}
