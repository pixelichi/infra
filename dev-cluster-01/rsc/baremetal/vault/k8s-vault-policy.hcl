# Enable the Kubernetes auth backend
path "sys/auth/kubernetes" {
  capabilities = ["create", "read", "update", "delete"]
}

# Configure the Kubernetes auth backend
path "auth/kubernetes/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Optional: Permissions to manage policies, roles, etc.
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["update"]
}
