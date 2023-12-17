
resource "kubernetes_namespace" "minio" {
  metadata {
    name = "minio"
  }
}

resource "kubernetes_service_account" "minio_sa" {
  metadata {
    name      = "minio-sa"
    namespace = "default"
  }
}

# Storage (PVC / PV) =========================================

resource "kubernetes_persistent_volume" "minio_pv" {
  metadata {
    name = "minio-pv"
  }

  spec {

    capacity = {
      storage = "10Gi"
    }

    access_modes = ["ReadWriteOnce"]
    # persistent_volume_reclaim_policy = "Retain"
    persistent_volume_reclaim_policy = "Recycle"
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

  depends_on = [kubernetes_persistent_volume.minio_pv, ]

}


# Minio Service =========================================

resource "kubernetes_pod" "minio_pod" {
  metadata {
    name = "minio-pod"
    labels = {
      App = "minio"
    }
    # https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations 
    # https://github.com/hashicorp/vault-k8s/blob/main/agent-inject/agent/annotations.go
    annotations = {
      "vault.hashicorp.com/agent-inject"                       = "true"
      "vault.hashicorp.com/role"                               = vault_kubernetes_auth_backend_role.minio_secrets_read.role_name
      "vault.hashicorp.com/agent-inject-secret-access_key"     = "secret/terraform/minio"
      "vault.hashicorp.com/agent-inject-template-access_key"   = "{{- with secret \"secret/terraform/minio\" -}}export MINIO_ACCESS_KEY={{ .Data.data.access_key }}{{- end }}"
      "vault.hashicorp.com/agent-inject-secret-secret_token"   = "secret/data/terraform/minio"
      "vault.hashicorp.com/agent-inject-template-secret_token" = "{{- with secret \"secret/terraform/minio\" -}}export MINIO_SECRET_TOKEN={{ .Data.data.secret_token }}{{- end }}"
    }
  }

  spec {
    service_account_name = kubernetes_service_account.minio_sa.metadata[0].name
    container {
      image = "minio/minio:latest"
      name  = "minio"

      args = [
        "server",
        "/data",
        "--console-address",
        ":9090"
      ]

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

      # volume_mount {
      #   mount_path = "/data"
      #   name       = "data"
      # }
    }

    # volume {
    #   name = "data"

    #   persistent_volume_claim {
    #     claim_name = kubernetes_persistent_volume_claim.minio_pvc.metadata[0].name
    #   }
    # }
  }

  timeouts {
    create = "20s"
  }
}


# Permissions ===========================================

resource "vault_generic_secret" "minio_secrets" {
  # Shouldn't have data in the path, or else it repeats in the logging output
  path = "secret/terraform/minio"
  data_json = jsonencode({
    access_key   = random_string.minio_secret_key.result
    secret_token = random_string.minio_access_key.result
  })

  depends_on = [vault_mount.kv]
}

resource "vault_kubernetes_auth_backend_role" "minio_secrets_read" {
  role_name                        = "vault-kubernetes-auth"
  backend                          = vault_auth_backend.kubernetes.path
  bound_service_account_names      = ["${kubernetes_service_account.minio_sa.metadata[0].name}"]
  bound_service_account_namespaces = ["${kubernetes_service_account.minio_sa.metadata[0].namespace}"] // Leaving empty for now because I don't know what I'm doing
  token_policies                   = [local.read_minio_secrets_policy_name]
  alias_name_source                = "serviceaccount_name"
  token_no_default_policy          = true
}


locals {
  read_minio_secrets_policy_name = "read-minio-secrets"
}

resource "vault_policy" "read_minio_secrets" {
  name   = local.read_minio_secrets_policy_name
  policy = <<-EOT
    path "secret/terraform/minio" {
      capabilities = ["read"]
    }

    path "secret/data/terraform/minio" {
      capabilities = ["read"]
    }

    path "auth/token/lookup-self" {
      capabilities = ["read"]
    }

    path "sys/capabilities-self/*" {
      capabilities = ["update"]
    }

    path "auth/token/renew-self" {
      capabilities = ["update"]
    }

    path "auth/token/revoke-self" {
      capabilities = ["update"]
    }
  EOT
}


# Generation of Secrets ================================

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
