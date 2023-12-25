
resource "kubernetes_deployment" "api_server_deploy" {

  metadata {
    name      = "${var.namespace}-deployment"
    namespace = kubernetes_namespace.backend.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.namespace
      }
    }

    template {
      metadata {
        labels = {
          app = var.namespace
        }

        annotations = {
          # https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations 
          # https://github.com/hashicorp/vault-k8s/blob/main/agent-inject/agent/annotations.go
          "vault.hashicorp.com/agent-inject" = "true"
          "vault.hashicorp.com/role"         = module.secrets_role.vault_secret_role

          "vault.hashicorp.com/agent-inject-secret-.env"   = "secret/data/terraform"
          "vault.hashicorp.com/agent-inject-template-.env" = <<EOF
{{- with secret "${var.db_secret_path}" -}}
DB_NAME="{{ .Data.data.postgres_db }}"
DB_USER="{{ .Data.data.postgres_user }}"
DB_PASS="{{ .Data.data.postgres_password }}"
DB_HOST="db.db.svc.cluster.local:5432"
DB_SOURCE="postgresql://{{ .Data.data.postgres_user }}:{{ .Data.data.postgres_password }}@db.db.svc.cluster.local:5432/{{ .Data.data.postgres_db }}?sslmode=disable"
{{- end }}
{{ with secret "${var.minio_secret_path}" -}}
MINIO_ROOT_USER="{{ .Data.data.minio_root_user }}"
MINIO_ROOT_PASSWORD="{{ .Data.data.minio_root_password }}"
MINIO_ENDPOINT="minio.minio.svc.cluster.local:9000"
MINIO_PUBLIC_ENDPOINT=obj.shinypothos.com
{{- end }}
{{ with secret "${var.backend_secret_path}" -}}
TOKEN_SYMMETRIC_KEY="{{ .Data.data.token_symmetric_key }}"
{{- end }}
EOF
        }
      }
      spec {
        service_account_name = kubernetes_service_account.backend.metadata[0].name
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

  # https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    create = "30s"
    update = "30s"
    delete = "30s"
  }
}

resource "kubernetes_service" "api_server_service" {
  metadata {
    name      = "${var.namespace}-service"
    namespace = kubernetes_namespace.backend.metadata.0.name

    annotations = {
      # "external-dns.alpha.kubernetes.io/hostname" = "pixelichi.com"
    }
  }

  spec {
    selector = {
      app = var.namespace
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

