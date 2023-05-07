
resource "kubernetes_service" "jenkins_main_service" {

  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins-main.metadata.0.name
  }

  spec {
    cluster_ip = "None"
    selector = {
      app = "jenkins"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }
}
