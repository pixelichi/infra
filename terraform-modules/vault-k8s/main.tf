resource "kubernetes_namespace" "vault_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  namespace        = kubernetes_namespace.vault_namespace.metadata[0].name
  create_namespace = false

  # values = [
  #   yamlencode({
  #     server = {
  #       persistentVolumeClaimRetentionPolicy = {
  #         whenDeleted = "Delete"
  #         whenScaled  = "Delete"
  #       }
  #     }
  #   }),
  # ]

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
    value = "vault-hostpath"
  }
}

resource "helm_release" "vault_operator" {
  # Don't make the name longer it fucks up terraform
  name             = "vault-op"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  create_namespace = false
  namespace        = kubernetes_namespace.vault_namespace.metadata[0].name
}
