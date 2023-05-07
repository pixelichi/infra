resource "kubernetes_namespace" "jenkins-main" {
  metadata {
    name = "jenkins-main"
  }
}
