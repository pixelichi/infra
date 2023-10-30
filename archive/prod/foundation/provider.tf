
terraform {
  backend "s3" {
    bucket = "shinypothos-terraform"
    key    = "cluster/terraform.tfstate"
    region = "sfo3"
    endpoint = "https://sfo3.digitaloceanspaces.com"
    acl    = "private"
    encrypt = true

    // Not applicable for Digital Ocean Spaces
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check = true

    }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


variable "DO_TOKEN" {}

provider "digitalocean" {
  token = var.DO_TOKEN
}
