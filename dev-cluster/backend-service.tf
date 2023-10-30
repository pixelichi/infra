
resource "kubernetes_namespace" "api_server" {
  metadata {
    name = "api-server"
  }
}

resource "kubernetes_deployment" "api_server_deploy" {

  metadata {
    name      = "api-server-deployment"
    namespace = kubernetes_namespace.api_server.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "api-server"
        }
      }

      spec {
        container {
          name              = "backend"
          image             = "backend:latest"
          image_pull_policy = "Never"

          port {
            container_port = 1337
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "api_server_service" {
  metadata {
    name      = "api-server-service"
    namespace = kubernetes_namespace.api_server.metadata.0.name

    annotations = {
      # "external-dns.alpha.kubernetes.io/hostname" = "pixelichi.com"
    }
  }

  spec {
    selector = {
      app = "api-server"
    }

    port {
      name        = "http"
      port        = 1337
      target_port = 1337
      node_port   = 31000
    }

    type = var.use_load_balancer ? "LoadBalancer" : "NodePort"
  }
}

