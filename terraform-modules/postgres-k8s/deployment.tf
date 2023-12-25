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
        annotations = {
          # https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations 
          # https://github.com/hashicorp/vault-k8s/blob/main/agent-inject/agent/annotations.go
          "vault.hashicorp.com/agent-inject" = "true"
          "vault.hashicorp.com/role"         = module.setup_vault_permissions.vault_secret_role

          "vault.hashicorp.com/agent-inject-secret-postgres_db"   = var.vault_secrets_path
          "vault.hashicorp.com/agent-inject-template-postgres_db" = <<EOF
{{- with secret "${var.vault_secrets_path}" -}}
{{ .Data.data.postgres_db }}
{{- end }}
EOF

          "vault.hashicorp.com/agent-inject-secret-postgres_user"   = var.vault_secrets_path
          "vault.hashicorp.com/agent-inject-template-postgres_user" = <<EOF
{{- with secret "${var.vault_secrets_path}" -}}
{{ .Data.data.postgres_user }}
{{- end }}
EOF

          "vault.hashicorp.com/agent-inject-secret-postgres_password"   = var.vault_secrets_path
          "vault.hashicorp.com/agent-inject-template-postgres_password" = <<EOF
{{- with secret "${var.vault_secrets_path}" -}}
{{ .Data.data.postgres_password }}
{{- end }}
EOF
        }
      }


      spec {
        service_account_name = kubernetes_service_account.db_sa.metadata[0].name
        container {
          # https://www.postgresql.org/docs/16/index.html
          image = "postgres:16"
          name  = "postgres"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB_FILE"
            value = "/vault/secrets/postgres_db"
          }

          env {
            name  = "POSTGRES_USER_FILE"
            value = "/vault/secrets/postgres_user"
          }

          env {
            name  = "POSTGRES_PASSWORD_FILE"
            value = "/vault/secrets/postgres_password"
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

  # https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    create = "30s"
    update = "30s"
    delete = "30s"
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
