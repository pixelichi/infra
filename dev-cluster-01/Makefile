CLUSTER_NAME="jtrack"

default:
	./tf init
	./tf apply

fwd-assets:
	./scripts/port-forward.sh "static-asset" "static-asset-service" 3000 80

fwd-api:
	./scripts/port-forward.sh "api-server" "api-server-service" 1337 1337
	
fwd-db:
	./scripts/port-forward.sh "db" "db" 5432 5432

fwd-minio:
	./scripts/port-forward.sh "minio" "minio" 9000 9000
	./scripts/port-forward.sh "minio" "minio" 9090 9090

fwd-vault:
	./scripts/port-forward.sh "vault" "vault" 8200 8200
	./scripts/port-forward.sh "vault" "vault" 8201 8201
	# 
	# Please run the following command before using vault CLI!
	# export VAULT_ADDR='http://127.0.0.1:8200'
	# 

load-images:
	kind -n $(CLUSTER_NAME) load docker-image backend:latest

POSTGRES_POD_NAME = $(shell kubectl -n db get pods | grep db | awk '{ print $$1 }')
psql:
	kubectl exec -n db -it $(POSTGRES_POD_NAME) -- psql -h localhost -U admin -d db

clean-state:
	rm -rf .terraform
	rm terraform.tfstate
	rm terraform.tfstate.backup