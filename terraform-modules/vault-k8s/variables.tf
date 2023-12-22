variable "namespace" {
  type        = string
  description = "Namespace to be created and for Vault to be deployed in."
  default     = "vault"
}

variable "log_level" {
  type        = string
  description = "Log Level for whole vault deployment. Any of trace, debug, info, warn, error."
  default     = "info"
}

variable "host_data_path" {
  type        = string
  description = "The path on the node which should be used for persistence."
  default     = "/mnt/vault"
}

variable "nodeport" {
  type    = string
  default = "30010"
}

variable "k8s_cluster_ca_certificate" {
  type        = string
  description = "kubernetes cluster ca certificate. Used for setting up kubernetes provider."
}
