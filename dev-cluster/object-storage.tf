
resource "kubernetes_namespace" "minio" {
  metadata {
    name = "minio"
  }
}

resource "kubernetes_persistent_volume" "minio_pv" {
  metadata {
    name = "minio-pv"
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
        path = "/mnt/object"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "minio_pvc" {
  metadata {
    name      = "minio-pvc"
    namespace = kubernetes_namespace.minio.metadata[0].name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.STORAGE_CLASS

    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.minio_pv.metadata[0].name
  }
}

resource "kubernetes_deployment" "minio" {
  metadata {
    name      = "minio"
    namespace = kubernetes_namespace.minio.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "minio"
      }
    }

    template {
      metadata {
        labels = {
          App = "minio"
        }
      }

      spec {
        container {
          image = "minio/minio:latest"
          name  = "minio"

          args = [
            "server",
            "/data",
            "--console-address",
            ":9090"
          ]

          env {
            name = "MINIO_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = vault_generic_secret.minio_secrets.id
                key  = local.minio_access_key_key
              }
            }
          }

          env {
            name = "MINIO_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = vault_generic_secret.minio_secrets.id
                key  = local.minio_secret_token_key
              }
            }
          }

          port {
            container_port = 9000
          }

          readiness_probe {
            http_get {
              path = "/minio/health/ready"
              port = 9000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/minio/health/live"
              port = 9000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          volume_mount {
            mount_path = "/data"
            name       = "data"
          }
        }

        volume {
          name = "data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.minio_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

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

# Secrets for minio deployment ===========================================

locals {
  minio_secrets_path     = "secret/minio-secrets"
  minio_access_key_key   = "access_key"
  minio_secret_token_key = "secret_key"
}

resource "vault_generic_secret" "minio_secrets" {
  path = local.minio_secrets_path
  data_json = jsonencode({
    secret_key = random_string.minio_secret_key.result
    access_key = random_string.minio_access_key.result,
  })
}

resource "vault_kubernetes_auth_backend_role" "name" {
  role_name                        = "vault-kubernetes-auth"
  backend                          = vault_auth_backend.kubernetes.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["minio"]
}


resource "vault_policy" "read_minio_secrets" {
  name   = "read-minio-secrets"
  policy = <<-EOT
    path "${local.minio_secrets_path}" {
      capabilities = ["read"]
    }
  EOT
}

resource "random_string" "minio_access_key" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_string" "minio_secret_key" {
  length  = 40
  special = false
  upper   = true
  lower   = true
  numeric = true
}
