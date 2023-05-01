data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket     = "shinypothos-terraform"
    key        = "dev/01-foundation/terraform.tfstate"
    region     = "sfo3"
    endpoint   = "https://sfo3.digitaloceanspaces.com"
    acl        = "private"
    encrypt    = true
    access_key = var.SPACES_ACCESS_KEY
    secret_key = var.SPACES_SECRET_KEY

    // Not applicable for Digital Ocean Spaces
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
