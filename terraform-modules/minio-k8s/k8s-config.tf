
resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "minio_sa" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.minio.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = "vault-tokenreview-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.vault_tokenreview.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.minio_sa.metadata[0].name
    namespace = kubernetes_service_account.minio_sa.metadata[0].namespace
  }
}


resource "kubernetes_cluster_role" "vault_tokenreview" {
  metadata {
    name = "vault-tokenreview"
  }

  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
}
