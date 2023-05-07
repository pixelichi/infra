resource "kubernetes_deployment" "jenkins_deployment" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins-main.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        container {
          image             = "jenkins/jenkins:lts"
          image_pull_policy = "Always"
          name              = "jenkins"

          port {
            container_port = 8080
            name           = "http-port"
          }

          port {
            container_port = 50000
            name           = "jnlp-port"
          }

          volume_mount {
            mount_path = "/var"
            name       = "jenkins-home"
          }
        }

        volume {
          name = "jenkins-home"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins-pvc.metadata[0].name
            read_only  = false
          }
        }
      }
    }
  }
}
