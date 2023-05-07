resource "kubernetes_persistent_volume_claim" "jenkins-pvc" {
  metadata {
    name      = "jenkins-main-deployment-pvc"
    namespace = kubernetes_namespace.jenkins-main.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = kubernetes_storage_class.do-block-retain-storage-class.metadata[0].name
  }
}
