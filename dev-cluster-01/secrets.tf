resource "vault_generic_secret" "minio_secrets" {
  path = "secret/terraform/minio"
  data_json = jsonencode({
    minio_root_user     = ""
    minio_root_password = ""
  })

  depends_on = [vault_mount.kv]
}
