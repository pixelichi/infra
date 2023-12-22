
resource "vault_kubernetes_auth_backend_role" "minio_secrets_read" {
  role_name                        = "vault-kubernetes-auth-${var.service_account_name}-${var.namespace_name}"
  backend                          = "kubernetes"
  bound_service_account_names      = ["${var.service_account_name}"]
  bound_service_account_namespaces = ["${var.namespace_name}"]
  token_policies                   = [vault_policy.policy.name]
  alias_name_source                = "serviceaccount_name"
  token_no_default_policy          = true
}

resource "vault_policy" "policy" {
  name   = var.vault_policy_name
  policy = var.vault_policy
}


resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = "vault-tokenreview-binding-${var.service_account_name}-${var.namespace_name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.vault_tokenreview.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.service_account_name
    namespace = var.namespace_name
  }
}

resource "kubernetes_cluster_role" "vault_tokenreview" {
  metadata {
    name = "vault-tokenreview-${kubernetes_service_account.sa.metadata[0].name}-${kubernetes_service_account.sa.metadata[0].namespace}"
  }

  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
}

