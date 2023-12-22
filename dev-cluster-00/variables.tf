variable "k8s_host" {
  type        = string
  description = "Kubernetes host endpoint, used for setting up kubernetes provider."
}

variable "k8s_token" {
  type        = string
  description = "authentication token for kubernetes. Used for setting up kubernetes provider."
}

variable "k8s_cluster_ca_certificate" {
  type        = string
  description = "kubernetes cluster ca certificate. Used for setting up kubernetes provider."
}
