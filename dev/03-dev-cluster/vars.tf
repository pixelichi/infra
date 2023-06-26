variable "project_name" {
  default = "shinypothos"
}

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

