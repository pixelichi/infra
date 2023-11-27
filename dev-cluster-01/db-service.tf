resource "kubernetes_namespace" "db" {
  metadata {
    name = "db"
  }
}

resource "kubernetes_secret" "db" {
  metadata {
    name      = "db"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  # https://github.com/docker-library/docs/blob/master/postgres/README.md
  data = {
    "POSTGRES_USER"     = var.DB_USER
    "POSTGRES_PASSWORD" = var.DB_PASS
    "POSTGRES_DB"       = var.DB_NAME
  }
}

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

resource "kubernetes_persistent_volume" "db_pv" {
  metadata {
    name = "db-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.STORAGE_CLASS
    persistent_volume_source {
      host_path {
        # Inside the kind-node-plane container - aka the node
        path = "/mnt/db"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "db" {
  metadata {
    name      = "db-pvc"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.STORAGE_CLASS

    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.db_pv.metadata.0.name
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
