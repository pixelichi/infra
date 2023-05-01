#!/bin/bash -e

# tldr; we get away with using spaces for the remote backend because it conforms to the S3 API
# However, it's not all perfect for authentication, so we have to do this for the first init
# https://dev.to/jmarhee/digitalocean-spaces-as-a-terraform-backend-3lck
terraform init \
  -backend-config="access_key=$SPACES_SECRET_KEY" \
  -backend-config="secret_key=$SPACES_ACCESS_TOKEN" \
  -backend-config="bucket=$SPACES_BUCKET_NAME" "$@"
