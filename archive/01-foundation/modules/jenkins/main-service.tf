
resource "kubernetes_service" "jenkins_main_service" {

  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins-main.metadata.0.name
  }

  spec {
    cluster_ip = "10.245.255.254"

    selector = {
      app = "jenkins"
    }

    port {
      name        = "http-port"
      port        = 8080
      target_port = 8080
    }

    port {
      name        = "jnlp-port"
      port        = 50000
      target_port = 50000
    }

    type = "LoadBalancer"
  }
}
