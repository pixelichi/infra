terraform {

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_cluster
provider "kubernetes" {
  host                   = var.HOST
  token                  = var.TOKEN
  cluster_ca_certificate = var.CLUSTER_CA_CERTIFICATE
}

