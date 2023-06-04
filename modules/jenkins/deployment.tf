resource "kubernetes_deployment" "jenkins_main_deployment" {
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

        security_context {
          fs_group    = 1000
          run_as_user = 1000
        }

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
            name       = kubernetes_persistent_volume_claim.jenkins-pvc.metadata[0].name
            mount_path = "/var/jenkins_home"
          }
        }

        volume {
          name = kubernetes_persistent_volume_claim.jenkins-pvc.metadata[0].name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins-pvc.metadata[0].name
            read_only  = false
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_persistent_volume_claim.jenkins-pvc
  ]
}
