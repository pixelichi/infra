resource "digitalocean_kubernetes_cluster" "cluster" {
  name     = "${var.project_name}-${var.env}-cluster"
  region   = var.region
  version  = var.kubernetes_version
  vpc_uuid = data.terraform_remote_state.foundation.outputs.vpc-id

  registry_integration = true

  node_pool {
    name = "${var.project_name}-${var.env}-node-pool"

    # https://docs.digitalocean.com/reference/api/api-reference/#tag/Sizes
    size = "s-1vcpu-2gb"

    auto_scale = true
    min_nodes  = 1
    max_nodes  = 1
  }
}
