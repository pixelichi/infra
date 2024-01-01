resource "kubernetes_namespace" "terraform_namespace" {
  metadata {
    name = "terraform-namespace"
  }
}

resource "kubernetes_service_account" "terraform_account" {
  metadata {
    name      = "terraform-account"
    namespace = kubernetes_namespace.terraform_namespace.metadata[0].name
  }
}

resource "kubernetes_secret" "terraform_account_secret" {
  metadata {
    name      = "terraform-account-secret"
    namespace = kubernetes_namespace.terraform_namespace.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.terraform_account.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}
