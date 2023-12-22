resource "vault_generic_secret" "minio_secrets" {
  path = "secret/terraform/db"
  data_json = jsonencode({
    postgres_user     = random_string.db_user.result
    postgres_password = random_string.db_pass.result
    postgres_db       = var.db_name
  })
}

resource "random_string" "db_user" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_string" "db_pass" {
  length  = 40
  special = false
  upper   = true
  lower   = true
  numeric = true
}


