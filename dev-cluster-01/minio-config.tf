
resource "kubernetes_namespace" "minio" {
  metadata {
    name = "minio"
  }
}

resource "kubernetes_service_account" "minio_sa" {
  metadata {
    name      = "minio-sa"
    namespace = kubernetes_namespace.minio.metadata[0].name
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

# Permissions ===========================================

resource "vault_generic_secret" "minio_secrets" {
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
  token_policies                   = [vault_policy.read_minio_secrets.name]
  alias_name_source                = "serviceaccount_name"
  token_no_default_policy          = true
}

resource "vault_policy" "read_minio_secrets" {
  name   = "read-minio-secrets"
  policy = <<-EOT
    path "secret/data/terraform/minio" {
      capabilities = ["read"]
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
