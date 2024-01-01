os_user=ubuntu

default: apply

init:
	./tf init

apply: init
	@echo "yes" | ./tf apply


destroy:
	@echo "yes" | ./tf destroy


refresh: destroy apply

tunnel-k8s:
	pushd ../prod-00; ../rsc/scripts/util/tunnel.sh -u $(os_user) -h "$$(terraform output -raw controller_public_ip)" -i ~/.ssh/aws-key -l 6443 -r 6443


setup-vault:
	# Proxies Vault service to local, and then unseals vault
	../rsc/scripts/initialize-vault/initialize-vault.sh

	
destroy-cluster:
	kind delete cluster --name $(CLUSTER_NAME)


refresh-cluster: destroy-cluster create-cluster


fwd-vault:
	../rsc/scripts/k8s/port-forward.sh "vault" "vault" 8200 8200
	../rsc/scripts/k8s/port-forward.sh "vault" "vault" 8201 8201

fwd-stop-vault:
	lsof -i :"8200" | awk 'NR>1 {print $$2}' | xargs -r kill -9
	lsof -i :"8201" | awk 'NR>1 {print $$2}' | xargs -r kill -9

terraform-token:
	vault token create -policy="terraform-policy" -format=yaml -field=token
