
# resource "kubernetes_deployment" "minio" {

#   metadata {
#     name      = "minio"
#     namespace = kubernetes_namespace.minio.metadata[0].name
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         App = "minio"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           App = "minio"
#         }
#         annotations = {
#           # https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations 
#           # https://github.com/hashicorp/vault-k8s/blob/main/agent-inject/agent/annotations.go
#           "vault.hashicorp.com/agent-inject"                       = "true"
#           "vault.hashicorp.com/role"                               = vault_kubernetes_auth_backend_role.minio_secrets_read.role_name
#           "vault.hashicorp.com/agent-inject-secret-access_key"     = "secret/data/terraform/minio"
#           "vault.hashicorp.com/agent-inject-template-access_key"   = "{{- with secret \"secret/data/terraform/minio\" -}}export MINIO_ACCESS_KEY={{ .Data.data.access_key }}{{- end }}"
#           "vault.hashicorp.com/agent-inject-secret-secret_token"   = "secret/terraform/minio"
#           "vault.hashicorp.com/agent-inject-template-secret_token" = "{{- with secret \"secret/data/terraform/minio\" -}}export MINIO_SECRET_TOKEN={{ .Data.data.secret_token }}{{- end }}"
#         }
#       }

#       spec {
#         container {
#           image = "minio/minio:latest"
#           name  = "minio"

#           args = [
#             "server",
#             "/data",
#             "--console-address",
#             ":9090"
#           ]

#           # env {
#           #   name = "MINIO_ACCESS_KEY"
#           #   value_from {
#           #     secret_key_ref {
#           #       name = vault_generic_secret.minio_secrets.
#           #       key  = "access-key"
#           #     }
#           #   }
#           # }

#           # env {
#           #   name = "MINIO_SECRET_KEY"
#           #   value_from {
#           #     secret_key_ref {
#           #       name = vault_generic_secret.minio_secrets.id
#           #       key  = "secret-key"
#           #     }
#           #   }
#           # }

#           port {
#             container_port = 9000
#           }

#           readiness_probe {
#             http_get {
#               path = "/minio/health/ready"
#               port = 9000
#             }
#             initial_delay_seconds = 5
#             period_seconds        = 10
#           }

#           liveness_probe {
#             http_get {
#               path = "/minio/health/live"
#               port = 9000
#             }
#             initial_delay_seconds = 5
#             period_seconds        = 10
#           }

#           volume_mount {
#             mount_path = "/data"
#             name       = "data"
#           }
#         }

#         volume {
#           name = "data"

#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim.minio_pvc.metadata[0].name
#           }
#         }
#       }
#     }
#   }

#   depends_on = [kubernetes_persistent_volume.minio_pv, kubernetes_persistent_volume_claim.minio_pvc]
# }

# resource "kubernetes_service" "minio" {
#   metadata {
#     name      = "minio"
#     namespace = kubernetes_namespace.minio.metadata[0].name
#   }

#   spec {
#     selector = {
#       App = "minio"
#     }

#     port {
#       name        = "api"
#       port        = 9000
#       target_port = 9000
#       node_port   = 30001
#     }

#     port {
#       name        = "ui"
#       port        = 9090
#       target_port = 9090
#       node_port   = 30002
#     }


#     type = var.use_load_balancer ? "LoadBalancer" : "NodePort"
#   }
# }
