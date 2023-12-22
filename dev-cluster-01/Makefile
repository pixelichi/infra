CLUSTER_NAME = jtrack
export VAULT_ADDR = http://127.0.0.1:8200

default: deploy

deploy: fwd-vault
	./tf init
	echo "yes" | ./tf apply
	@echo "\n\n** Please log into vault through the UI interface and set the appropriate secrets in secrets/terraform/* **"

fwd-vault:
	./scripts/port-forward.sh "vault" "vault" 8200 8200
	./scripts/port-forward.sh "vault" "vault" 8201 8201

fwd-stop-vault:
	lsof -i :"8200" | awk 'NR>1 {print $$2}' | xargs -r kill -9
	lsof -i :"8201" | awk 'NR>1 {print $$2}' | xargs -r kill -9

terraform-token:
	vault token create -policy="terraform-policy" -format=yaml -field=token
