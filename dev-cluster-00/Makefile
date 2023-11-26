CLUSTER_NAME = jtrack

setup-local-env:
	./scripts/setup-local-machine/setup-local-machine.sh


create-cluster:
	./scripts/create-cluster/create-cluster.sh $(CLUSTER_NAME)
	./tf init
	./tf apply
	./scripts/initialize-vault/initialize-vault.sh

	
destroy-cluster:
	kind delete cluster --name $(CLUSTER_NAME)


refresh-cluster: destroy-cluster create-cluster


proxy-vault:
	./scripts/proxy-stop-vault/proxy-stop-vault.sh


proxy-stop-vault:
	./scripts/proxy-vault/proxy-vault.sh