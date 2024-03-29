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
  host                   = var.k8s_host
  token                  = var.k8s_token
  cluster_ca_certificate = var.k8s_cluster_ca_certificate
}

provider "vault" {
  # Assumed the caller has already ran fwd-vault before running terraform script
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}

provider "random" {}
