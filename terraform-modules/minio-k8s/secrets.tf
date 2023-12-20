resource "vault_generic_secret" "minio_secrets" {
  path = "secret/terraform/minio"
  data_json = jsonencode({
    access_key   = random_string.minio_secret_key.result
    secret_token = random_string.minio_access_key.result
  })
}

resource "random_string" "minio_access_key" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_string" "minio_secret_key" {
  length  = 40
  special = false
  upper   = true
  lower   = true
  numeric = true
}
