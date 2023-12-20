
resource "kubernetes_service" "minio" {
  metadata {
    name      = "minio"
    namespace = kubernetes_namespace.minio.metadata[0].name
  }

  spec {
    selector = {
      App = "minio"
    }

    port {
      name        = "api"
      port        = 9000
      target_port = 9000
      node_port   = 30001
    }

    port {
      name        = "ui"
      port        = 9090
      target_port = 9090
      node_port   = 30002
    }


    type = var.use_load_balancer ? "LoadBalancer" : "NodePort"
  }
}
