terraform {
  backend "s3" {
    bucket   = "shinypothos-terraform"
    key      = "dev/02-cluster/terraform.tfstate"
    region   = "sfo3"
    endpoint = "https://sfo3.digitaloceanspaces.com"
    acl      = "private"
    encrypt  = true

    access_key = var.SPACES_ACCESS_KEY
    secret_key = var.SPACES_SECRET_KEY

    // Not applicable for Digital Ocean Spaces
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true

  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "digitalocean" {
  token = var.DO_TOKEN
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_cluster
provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.cluster.endpoint
  token = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  provider "kubernetes" {
    host  = digitalocean_kubernetes_cluster.cluster.endpoint
    token = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
    )
  }
}
