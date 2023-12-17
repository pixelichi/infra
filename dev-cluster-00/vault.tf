
locals {
  vault_namespace = "vault"
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  namespace        = local.vault_namespace
  create_namespace = true # Create the "vault" namespace if it doesn't exist

  set {
    name  = "injector.logLevel"
    value = "trace"
  }

  set {
    name  = "server.logLevel"
    value = "trace"
  }
}

resource "helm_release" "vault_operator" {
  name             = "vault-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  create_namespace = false
  namespace        = local.vault_namespace

  depends_on = [helm_release.vault]
}

