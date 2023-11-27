# Secret related Permissions =======================

path "secret/terraform/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/terraform/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Token related Permissions ========================

path "auth/token/create" {
  capabilities = ["update"]
}


# Mount related Permissions ========================

path "sys/mounts" {
  capabilities = ["read"]
}

path "sys/remount" {
  capabilities = ["read", "update", "create", "delete", "list", "sudo"]
}


path "sys/mounts/*" {
  capabilities = ["read", "update", "delete" , "create", "list"]
}


# Auth Related Permissions =========================

path "sys/auth/kubernetes/*" { # Necessary for setting up Kubernetes Backend
  capabilities = ["read", "update", "delete" , "create", "list", "sudo"]
}

path "sys/auth" {
  capabilities = ["read"]
}

path "auth/kubernetes/*" { # Necessary for setting up Kubernetes Backend
  capabilities = ["read", "update", "delete" , "create", "list", "sudo"]
}

# Policy Related Permissions =======================
path "sys/policies/acl/*" {
  capabilities = ["list"]
}

path "sys/policies/acl/terraform/*" {
  capabilities = ["create", "read", "update", "delete"]
}
