
proxy:
	# static asset service
	lsof -i :3000 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n static-asset port-forward service/static-asset-service 3000:80 --address 0.0.0.0 1>/dev/null &

	# API Server
	lsof -i :1337 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n api-server port-forward service/api-server-service 1337:1337 --address 0.0.0.0 1>/dev/null &
	
	# DB
	lsof -i :5432 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n db port-forward service/db 5432:5432 --address 0.0.0.0 1>/dev/null &


load-images:
	kind load docker-image backend:latest

create-cluster:
	kind create cluster --config="./rsc/kind/kind-cluster-config.yaml" --name "shinypothos" --wait 5m
	kubectl apply -f ./rsc/kind/terraform_namespace.yaml
	kubectl apply -f ./rsc/kind/cluster_role_binding.yaml
	kind --name shinypothos load docker-image backend:latest


destroy-cluster:
	kind delete cluster --name shinypothos

POSTGRES_POD_NAME = $(shell kubectl -n db get pods | grep db | awk '{ print $$1 }')
psql:
	kubectl exec -n db -it $(POSTGRES_POD_NAME) -- psql -h localhost -U admin -d db