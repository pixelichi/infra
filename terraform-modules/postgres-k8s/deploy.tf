resource "kubernetes_deployment" "db" {
  metadata {
    name      = "db"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.db_sa.metadata[0].name
        container {
          image = "postgres:15"
          name  = "postgres"

          env_from {
            secret_ref {
              name = kubernetes_secret.db.metadata[0].name
            }
          }

          port {
            container_port = 5432
          }

          volume_mount {
            # Inside the pod
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.db.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "db" {
  metadata {
    name      = "db"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  spec {
    selector = {
      app = "db"
    }

    port {
      name        = "http"
      port        = 5432
      target_port = 5432
      node_port   = 32000
    }

    type = var.use_load_balancer ? "LoadBalancer" : "NodePort"
  }
}
