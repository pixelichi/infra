terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_cluster
provider "kubernetes" {
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = var.cluster_ca_cert
}
