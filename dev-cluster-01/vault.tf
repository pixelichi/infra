resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  namespace        = "vault"
  create_namespace = true # Create the "vault" namespace if it doesn't exist

  values = [
    # Vault server configuration values go here (e.g., HA settings, authentication methods, etc.)
    # You can customize this based on your Vault deployment requirements
  ]
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}
