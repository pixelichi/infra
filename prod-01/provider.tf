# Configure the AWS Provider
provider "aws" {
  region = "us-east-2" # Must be hardcoded
}

# Configure Terraform to save state file in an S3 bucket
terraform {
  backend "s3" {
    bucket  = "tf-state-jtrack"
    key     = "prod-01/statefile.tfstate"
    region  = "us-east-2" # Must be hardcoded
    encrypt = true
  }
}

provider "kubernetes" {
  # We create the cluster in prod-00 so that is where you'll find the config
  config_path = "~/kube/prod-00/config"
}

provider "helm" {
  kubernetes {
    # We create the cluster in prod-00 so that is where you'll find the config
    config_path = "~/kube/prod-00/config"
  }
}
