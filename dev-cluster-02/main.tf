
module "minio_deployment" {
  source = "../terraform-modules/minio-k8s"
}

module "static-asset-server" {
  source = "../terraform-modules/static-asset-server"
}

module "postgres" {
  source = "../terraform-modules/postgres-k8s"
}
