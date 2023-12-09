CLUSTER_NAME = jtrack
export VAULT_ADDR = http://127.0.0.1:8200

default: create-cluster

setup-local-env:
	./scripts/setup-local-machine/setup-local-machine.sh


create-cluster:
	./scripts/create-cluster/create-cluster.sh $(CLUSTER_NAME)
	./tf init
	echo yes | ./tf apply
	./scripts/initialize-vault/initialize-vault.sh

	
destroy-cluster:
	kind delete cluster --name $(CLUSTER_NAME)


refresh-cluster: destroy-cluster create-cluster


fwd-vault:
	./scripts/port-forward.sh "vault" "vault" 8200 8200
	./scripts/port-forward.sh "vault" "vault" 8201 8201

fwd-stop-vault:
	lsof -i :"8200" | awk 'NR>1 {print $$2}' | xargs -r kill -9
	lsof -i :"8201" | awk 'NR>1 {print $$2}' | xargs -r kill -9

terraform-token:
	vault token create -policy="terraform-policy" -format=yaml -field=token
