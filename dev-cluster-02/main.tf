module "minio_deployment" {
  source             = "../terraform-modules/minio-k8s"
  vault_secrets_path = var.minio_secrets_path
}

module "static-asset-server" {
  source = "../terraform-modules/static-asset-server"
}

module "postgres" {
  source             = "../terraform-modules/postgres-k8s"
  vault_secrets_path = var.db_secrets_path
}

module "backend" {
  source              = "../terraform-modules/backend-k8s"
  db_secret_path      = var.db_secrets_path
  minio_secret_path   = var.minio_secrets_path
  backend_secret_path = var.backend_secrets_path
}
