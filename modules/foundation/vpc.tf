
resource "digitalocean_vpc" "shinypothos" {
  name     = "${var.project_name}-${var.env}-vpc"
  region   = var.region
  ip_range = var.vpc_cidr


  lifecycle {
    create_before_destroy = true
  }
}
