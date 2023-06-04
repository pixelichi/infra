locals {
  jenkins_sa_name = "jenkins-sa"
}

resource "kubernetes_service_account" "jenkins-sa" {
  metadata {
    name      = local.jenkins_sa_name
    namespace = kubernetes_namespace.jenkins-jnlp.metadata.0.name
  }

  secret {
    name = kubernetes_secret.jenkins-sa-token.metadata.0.name
  }
}

resource "kubernetes_secret" "jenkins-sa-token" {
  metadata {
    name      = "jenkins-sa-token"
    namespace = kubernetes_namespace.jenkins-jnlp.metadata.0.name
    annotations = {
      "kubernetes.io/service-account.name" = local.jenkins_sa_name
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_role" "jenkins-role" {
  metadata {
    name      = "jenkins-role"
    namespace = kubernetes_namespace.jenkins-jnlp.metadata.0.name
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }
}


resource "kubernetes_role_binding" "jenkins-role-binding" {
  metadata {
    name      = "jenkins-role-binding"
    namespace = kubernetes_namespace.jenkins-jnlp.metadata.0.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.jenkins-role.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins-sa.metadata.0.name
    namespace = kubernetes_namespace.jenkins-jnlp.metadata.0.name
  }
}
