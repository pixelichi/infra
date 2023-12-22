
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
        annotations = {
          # https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations 
          # https://github.com/hashicorp/vault-k8s/blob/main/agent-inject/agent/annotations.go
          "vault.hashicorp.com/agent-inject"                  = "true"
          "vault.hashicorp.com/role"                          = vault_kubernetes_auth_backend_role.minio_secrets_read.role_name
          "vault.hashicorp.com/agent-inject-secret-secrets"   = "secret/terraform/minio"
          "vault.hashicorp.com/agent-inject-template-secrets" = <<EOF
{{- with secret "secret/data/terraform/minio" -}}
MINIO_ROOT_USER={{ .Data.data.minio_root_user }}
MINIO_ROOT_PASSWORD={{ .Data.data.minio_root_password }}
{{- end }}
EOF
        }
      }

      spec {
        service_account_name = kubernetes_service_account.minio_sa.metadata[0].name
        container {
          image = var.minio_image
          name  = "minio"

          args = [
            "server",
            "/data",
            "--console-address",
            ":9090"
          ]

          # Using the following to read the vault secrets into env variables
          # https://min.io/docs/minio/container/operations/install-deploy-manage/deploy-minio-single-node-single-drive.html#id4
          env {
            name  = "MINIO_CONFIG_ENV_FILE"
            value = "/vault/secrets/secrets"
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

  # https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    create = "30s"
    update = "30s"
    delete = "30s"
  }

  depends_on = [kubernetes_persistent_volume.minio_pv, kubernetes_persistent_volume_claim.minio_pvc]
}
