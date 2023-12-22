resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "injector.logLevel"
    value = var.log_level
  }

  set {
    name  = "server.logLevel"
    value = var.log_level
  }

  # Necessary to use custom location on Node for deployment
  # This is necessary to have persistence past cluster destroys and recreated of the underlying data
  set {
    name  = "server.dataStorage.enabled"
    value = true
  }

  set {
    name  = "server.dataStorage.size"
    value = "10Gi"
  }

  set {
    name  = "server.dataStorage.storageClass"
    value = kubernetes_storage_class_v1.vault_hostpath.metadata[0].name
  }
}


resource "helm_release" "vault_operator" {
  name             = "vault-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  create_namespace = false
  namespace        = var.namespace

  # Depends on namespace creation
  depends_on = [helm_release.vault]
}
