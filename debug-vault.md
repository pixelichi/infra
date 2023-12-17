# Debugging Vault and Kubernetes Pod Secrets

### Vault Config
```json
{
    "auto_auth": {
        "method": {
            "type": "kubernetes",
            "mount_path": "auth/kubernetes",
            "config": {
                "role": "vault-kubernetes-auth",
                "token_path": "/var/run/secrets/kubernetes.io/serviceaccount/token"
            }
        },
        "sink": [
            {
                "type": "file",
                "config": {
                    "path": "/home/vault/.vault-token"
                }
            }
        ]
    },
    "exit_after_auth": true,
    "pid_file": "/home/vault/.pid",
    "vault": {
        "address": "http://vault.vault.svc:8200"
    },
    "template": [
        {
            "destination": "/vault/secrets/access_key",
            "contents": "{{- with secret \"secret/terraform/minio\" -}}export MINIO_ACCESS_KEY={{ .Data.data.access_key }}{{- end }}",
            "left_delimiter": "{{",
            "right_delimiter": "}}"
        },
        {
            "destination": "/vault/secrets/secret_token",
            "contents": "{{- with secret \"secret/terraform/minio\" -}}export MINIO_SECRET_TOKEN={{ .Data.data.secret_token }}{{- end }}",
            "left_delimiter": "{{",
            "right_delimiter": "}}"
        }
    ],
    "template_config": {
        "exit_on_retry_failure": true
    }
}```