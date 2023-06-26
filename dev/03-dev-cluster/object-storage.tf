
# resource "kubernetes_namespace" "minio" {
#   metadata {
#     name = "minio"
#   }
# }

# resource "random_string" "access_key" {
#   length  = 20
#   special = false
#   upper   = true
#   lower   = true
#   numeric = true
# }

# resource "random_string" "secret_key" {
#   length  = 40
#   special = false
#   upper   = true
#   lower   = true
#   numeric = true
# }

# resource "kubernetes_secret" "minio_credentials" {
#   metadata {
#     name      = "minio-credentials"
#     namespace = kubernetes_namespace.minio.metadata[0].name
#   }

#   data = {
#     accesskey = base64encode(random_string.access_key.result)
#     secretkey = base64encode(random_string.secret_key.result)
#   }

#   type = "Opaque"
# }


# resource "kubernetes_persistent_volume" "minio_pv" {
#   metadata {
#     name = "minio-pv"
#   }

#   spec {
#     capacity = {
#       storage = "10Gi"
#     }
#     access_modes                     = ["ReadWriteOnce"]
#     persistent_volume_reclaim_policy = "Retain"
#     storage_class_name               = "manual"
#     persistent_volume_source {
#       host_path {
#         path = "/mnt/object"
#       }
#     }
#   }
# }

# resource "kubernetes_persistent_volume_claim" "minio_pvc" {
#   metadata {
#     name      = "minio-pvc"
#     namespace = kubernetes_namespace.minio.metadata[0].name
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "10Gi"
#       }
#     }
#     volume_name = kubernetes_persistent_volume.minio_pv.metadata[0].name
#   }
# }

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
#       }

#       spec {
#         container {
#           image = "minio/minio:latest"
#           name  = "minio"

#           args = [
#             "server",
#             "/data",
#           ]

#           env {
#             name = "MINIO_ACCESS_KEY"
#             value_from {
#               secret_key_ref {
#                 name = kubernetes_secret.minio_credentials.metadata[0].name
#                 key  = "accesskey"
#               }
#             }
#           }

#           env {
#             name = "MINIO_SECRET_KEY"
#             value_from {
#               secret_key_ref {
#                 name = kubernetes_secret.minio_credentials.metadata[0].name
#                 key  = "secretkey"
#               }
#             }
#           }

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
#       port        = 9000
#       target_port = 9000
#     }

#     type = var.use_load_balancer ? "LoadBalancer" : "NodePort"
#   }
# }
