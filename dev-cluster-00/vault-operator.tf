resource "helm_release" "vault_operator" {
  name             = "vault-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  create_namespace = true
  namespace        = "vault-operator"

  depends_on = [helm_release.vault]
}
