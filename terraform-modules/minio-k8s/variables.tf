# Fields with defaults ===================================================================================
variable "namespace" {
  description = "Namespace that will be created to deploy minio inside of."
  type        = string
  default     = "minio"
}

variable "service_account_name" {
  description = "Name of the service account which will be used to deploy minio."
  type        = string
  default     = "minio-sa"
}

variable "STORAGE_CLASS" {
  # Unsure why this works...but for some reason we need to set this in order for the pv and pvc to match up
  default = "manual"
}

variable "host_data_path" {
  description = "Path on the host node that should be used to store data."
  type        = string
  default     = "/mnt/object"
}

variable "kubernetes_backend" {
  description = "Unique name of the kubernetes backend to configure."
  type        = string
  default     = "kubernetes"
}

variable "vault_role_name" {
  description = "Role Name to use for accessing appropriate secrets in vault"
  type        = string
  default     = "vault-secrets-minio"
}


variable "minio_image" {
  description = "Image you wish to deploy"
  type        = string
  default     = "minio/minio:latest"
}

variable "use_load_balancer" {
  description = "Set to true to use LoadBalancer, false to use NodePort"
  type        = bool
  default     = false
}

variable "vault_policy_name" {
  description = "The name of the vault policy which will be used to store secrets that the deployment pods can access."
  type        = string
  default     = "read-minio-secrets"
}

variable "vault_secrets_path" {
  description = "Location of where the secrets for the minio deployment are stored."
  type        = string
  default     = "secret/data/terraform/minio"
}
