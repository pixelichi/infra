
resource "kubernetes_persistent_volume" "nginx_pv" {
  metadata {
    name = "nginx-pv"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    # persistent_volume_reclaim_policy = "Retain"
    persistent_volume_reclaim_policy = "Recycle"
    storage_class_name               = var.STORAGE_CLASS
    persistent_volume_source {
      host_path {
        path = var.host_data_path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nginx_pvc" {

  metadata {
    name      = "nginx-pvc"
    namespace = kubernetes_namespace.static_asset.metadata.0.name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.STORAGE_CLASS

    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.nginx_pv.metadata.0.name
  }

}

