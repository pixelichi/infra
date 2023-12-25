# Required Params =============================================
variable "db_secret_path" {
  description = "Location for secrets for database to be stored in, used for deployment pods"
  type        = string
}

variable "minio_secret_path" {
  description = "Location for secrets for minio to be stored in, used for deployment pods"
  type        = string
}

variable "backend_secret_path" {
  description = "Location for secrets for backend to be stored in, used for deployment pods"
  type        = string
}

# Fields with defaults ========================================
variable "namespace" {
  description = "Namespace that will be created to deploy nginx inside of."
  type        = string
  default     = "backend"
}

variable "service_account_name" {
  description = "Service Account with this name will be created to deploy backend."
  type        = string
  default     = "backend-sa"
}

variable "use_load_balancer" {
  description = "Set to true to use LoadBalancer, false to use NodePort"
  type        = bool
  default     = false
}

