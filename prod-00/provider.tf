# Configure the AWS Provider
provider "aws" {
  region = "us-east-2" # Must be hardcoded
}

# Configure Terraform to save state file in an S3 bucket
terraform {
  backend "s3" {
    bucket  = "tf-state-jtrack"
    key     = "prod-00/statefile.tfstate"
    region  = "us-east-2" # Must be hardcoded
    encrypt = true
  }
}
