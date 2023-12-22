
resource "kubernetes_namespace" "static_asset" {
  metadata {
    name = var.namespace
  }
}
