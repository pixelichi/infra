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

provider "helm" {
  kubernetes {
    host                   = var.HOST
    token                  = var.TOKEN
    cluster_ca_certificate = var.CLUSTER_CA_CERTIFICATE
  }
}

data "external" "vault_address" {
  program = ["bash", "${path.module}/rsc/kind/scripts/get_vault_address.sh"]
}

# Extract the Vault address from the external data source result
locals {
  vault_address = data.external.vault_address.result["vault_address"]
}

provider "vault" {
  address = local.vault_address
  token   = helm_release.vault.name
}

provider "random" {}
