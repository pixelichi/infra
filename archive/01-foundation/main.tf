terraform {
  backend "s3" {
    bucket   = "shinypothos-terraform"
    key      = "dev/01-foundation/terraform.tfstate"
    region   = "sfo3"
    endpoint = "https://sfo3.digitaloceanspaces.com"
    acl      = "private"
    encrypt  = true

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
  }
}

provider "digitalocean" {
  token = var.DO_TOKEN
}

module "shinypothos-dev" {
  source       = "./modules/foundation"
  region       = "sfo3"
  env          = "dev"
  project_name = "shinypothos"
  vpc_cidr     = "10.0.0.0/16"
}
