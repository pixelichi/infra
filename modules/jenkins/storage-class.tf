# https://github.com/digitalocean/csi-digitalocean
# https://github.com/digitalocean/csi-digitalocean/tree/master/examples/kubernetes

resource "kubernetes_storage_class" "do-block-retain-storage-class" {
  metadata {
    name = "do-block-retain"
  }

  allow_volume_expansion = true
  storage_provisioner    = "dobs.csi.digitalocean.com"
  reclaim_policy         = "Retain"

  parameters = {
    "region" = "sfo3"
  }

  volume_binding_mode = "Immediate"
}
