module "vault" {
  source    = "../terraform-modules/vault-k8s"
  log_level = "info"
}
