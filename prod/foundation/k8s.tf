resource "digitalocean_kubernetes_cluster" "shinypothos-prod" {
  name    = "shinypothos-prod"
  region  = var.REGION
  version = "1.26.3-do.0"
  vpc_uuid = digitalocean_vpc.shinypothos.id

  registry_integration = true

  node_pool {
    name       = "shinypothos-prod-worker-pool"

    # https://docs.digitalocean.com/reference/api/api-reference/#tag/Sizes
    size       = "s-1vcpu-2gb"

    auto_scale = true
    min_nodes  = 1
    max_nodes  = 1
  }
}