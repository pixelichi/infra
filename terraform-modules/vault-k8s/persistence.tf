resource "kubernetes_storage_class_v1" "vault_hostpath" {
  metadata {
    name = "vault-hostpath"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
}


resource "kubernetes_persistent_volume_v1" "vault_pv" {
  metadata {
    name = "vault-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }

    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Delete"

    storage_class_name = kubernetes_storage_class_v1.vault_hostpath.metadata[0].name
    persistent_volume_source {
      host_path {
        path = var.host_data_path
      }
    }
  }

  timeouts {
    create = "30s"
  }
}
