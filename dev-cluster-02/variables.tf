variable "use_load_balancer" {
  description = "Set to true to use LoadBalancer, false to use NodePort"
  type        = bool
  default     = false
}

variable "HOST" {
}

variable "TOKEN" {
}

variable "CLUSTER_CA_CERTIFICATE" {
}

variable "DB_USER" {
  default = "admin"
}

# DON'T DEPLOY ME TO PROD WITHOUT CHANGING
variable "DB_PASS" {
  default = "password"
}

variable "DB_NAME" {
  default = "db"
}

variable "STORAGE_CLASS" {
  # Unsure why this works...but for some reason we need to set this in order for the pv and pvc to match up
  default = "manual"
}

variable "VAULT_TOKEN" {
}

variable "minio_secrets_path" {
  type        = string
  description = "The path in vault where the minio secrets are stored."
  default     = "secret/data/terraform/minio"
}

variable "db_secrets_path" {
  type        = string
  description = "The path in vault where the minio secrets are stored."
  default     = "secret/data/terraform/db"
}

variable "backend_secrets_path" {
  type        = string
  description = "The path in vault where the minio secrets are stored."
  default     = "secret/data/terraform/backend"
}
