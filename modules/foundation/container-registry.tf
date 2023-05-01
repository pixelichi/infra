# Create a new container registry
resource "digitalocean_container_registry" "shinypothos-registry" {
  name                   = "${var.project_name}-${var.env}-registry"
  subscription_tier_slug = "starter"
  region                 = var.region
}
