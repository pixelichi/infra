resource "kubernetes_persistent_volume" "db_pv" {
  metadata {
    name = "db-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Recycle"
    storage_class_name               = var.STORAGE_CLASS
    persistent_volume_source {
      host_path {
        # Inside the kind-node-plane container - aka the node
        path = var.host_data_path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "db" {
  metadata {
    name      = "db-pvc"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.STORAGE_CLASS

    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.db_pv.metadata.0.name
  }
}
