resource "kubernetes_deployment" "static_asset_server_deploy" {

  metadata {
    name      = "static-asset-server"
    namespace = kubernetes_namespace.static_asset.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "static-assets"
      }
    }

    template {
      metadata {
        labels = {
          app = "static-assets"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:stable-alpine"

          port {
            container_port = 80
          }

          volume_mount {
            # Inside the Pod
            name       = "nginx-data"
            mount_path = "/usr/share/nginx/html"
          }
        }

        volume {
          name = "nginx-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nginx_pvc.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "static_asset_service" {
  metadata {
    name      = "static-asset-service"
    namespace = kubernetes_namespace.static_asset.metadata.0.name

    annotations = {
      # "external-dns.alpha.kubernetes.io/hostname" = "pixelichi.com"
    }
  }

  spec {
    selector = {
      app = "static-assets"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
      node_port   = 30000
    }

    type = var.use_load_balancer ? "LoadBalancer" : "NodePort"
  }
}

