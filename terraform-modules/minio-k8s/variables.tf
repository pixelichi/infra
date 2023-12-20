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

variable "backend_role_name" {
  description = "vault_kubernetes_auth_backend_role name"
  type        = string
  default     = "vault-kubernetes-auth"
}

variable "vault_secret_read_policy_name" {
  description = "Name of the vault policy to create which allows reading of the minio access secrets"
  type        = string
  default     = "read-minio-secrets"
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
