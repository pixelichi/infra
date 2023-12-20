resource "kubernetes_persistent_volume" "minio_pv" {
  metadata {
    name = "minio-pv"
  }

  spec {

    capacity = {
      storage = "10Gi"
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

resource "kubernetes_persistent_volume_claim" "minio_pvc" {
  metadata {
    name      = "minio-pvc"
    namespace = kubernetes_namespace.minio.metadata[0].name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.STORAGE_CLASS

    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.minio_pv.metadata[0].name
  }

  depends_on = [kubernetes_persistent_volume.minio_pv, ]

}
