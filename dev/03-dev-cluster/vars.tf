variable "project_name" {
  default = "shinypothos"
}

variable "use_load_balancer" {
  description = "Set to true to use LoadBalancer, false to use NodePort"
  type        = bool
  default     = false
}

variable "STATIC_ASSETS_FOLDER" {
  default = "/home/share"
}

variable "HOST" {
}

variable "TOKEN" {
}

variable "CLUSTER_CA_CERTIFICATE" {
}

