# Create a new container registry
resource "digitalocean_container_registry" "shinypothos-registry" {
  name                   = "shinypothos-prod"
  subscription_tier_slug = "starter"
  region                 = var.REGION
}
