
module "minio_deployment" {
  source     = "../terraform-modules/minio-k8s"
  depends_on = [vault_mount.kv, vault_kubernetes_auth_backend_config.config]
}

module "static-asset-server" {
  source = "../terraform-modules/static-asset-server"
}
