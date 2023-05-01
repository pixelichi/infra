variable "REGION" {}

resource "digitalocean_vpc" "shinypothos" {
  name     = "shinypothos-vpc"
  region   = var.REGION
  ip_range = "10.0.0.0/16"
  

  lifecycle {
    create_before_destroy = true
  }
}