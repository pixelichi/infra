resource "kubernetes_namespace" "jenkins-main" {
  metadata {
    name = "jenkins-main"
  }
}

resource "kubernetes_namespace" "jenkins-jnlp" {
  metadata {
    name = "jenkins-jnlp"
  }
}
