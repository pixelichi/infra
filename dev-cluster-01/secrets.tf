resource "vault_generic_secret" "minio_secrets" {
  path = "secret/terraform/minio"
  data_json = jsonencode({
    minio_root_user     = ""
    minio_root_password = ""
  })

  depends_on = [vault_mount.kv]
}

resource "vault_generic_secret" "db_secrets" {
  path = "secret/terraform/db"
  data_json = jsonencode({
    postgres_user     = ""
    postgres_password = ""
    postgres_db       = ""
  })
}

resource "vault_generic_secret" "backend_secrets" {
  path = "secret/terraform/backend"
  data_json = jsonencode({
    token_symmetric_key = ""
  })
}
