variable "project_name" {
  default = "shinypothos"
}
variable "env" {
  default = "dev"
}

variable "region" {
  default = "sfo3"
}

variable "kubernetes_version" {
  default = "1.26.3-do.0"
}

variable "DO_TOKEN" {}
variable "SPACES_ACCESS_KEY" {}
variable "SPACES_SECRET_KEY" {}
