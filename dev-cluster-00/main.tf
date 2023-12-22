module "vault" {
  source                     = "../terraform-modules/vault-k8s"
  log_level                  = "info"
  k8s_cluster_ca_certificate = var.k8s_cluster_ca_certificate
}
