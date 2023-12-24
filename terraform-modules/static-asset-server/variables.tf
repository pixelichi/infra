# Fields with defaults ===================================================================================
variable "namespace" {
  description = "Namespace that will be created to deploy nginx inside of."
  type        = string
  default     = "static-asset"
}

variable "STORAGE_CLASS" {
  # Unsure why this works...but for some reason we need to set this in order for the pv and pvc to match up
  default = "manual"
}

variable "host_data_path" {
  description = "Path on the host node that should be used to store data."
  type        = string
  default     = "/mnt/ui"
}


variable "use_load_balancer" {
  description = "Set to true to use LoadBalancer, false to use NodePort"
  type        = bool
  default     = false
}
