
proxy: proxy-assets proxy-api proxy-db proxy-minio

get-all:
	kubectl get all --all-namespaces

proxy-assets:
	# static asset service
	lsof -i :3000 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n static-asset port-forward service/static-asset-service 3000:80 --address 0.0.0.0 1>/dev/null &

proxy-api:
	lsof -i :1337 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n api-server port-forward service/api-server-service 1337:1337 --address 0.0.0.0 1>/dev/null &

proxy-db:
	lsof -i :5432 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n db port-forward service/db 5432:5432 --address 0.0.0.0 1>/dev/null &

proxy-minio:
	lsof -i :9000 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n minio port-forward service/minio 9000:9000 --address 0.0.0.0 1>/dev/null &
	lsof -i :9090 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	kubectl -n minio port-forward service/minio 9090:9090 --address 0.0.0.0 1>/dev/null &

proxy-stop-minio:
	lsof -i :9000 | awk 'NR>1 {print $$2}' | xargs -r kill -9
	lsof -i :9090 | awk 'NR>1 {print $$2}' | xargs -r kill -9

load-images:
	kind load docker-image backend:latest

create-cluster:
	kubectl apply -f ./rsc/kind/terraform_namespace.yaml
	kubectl apply -f ./rsc/kind/cluster_role_binding.yaml

destroy-cluster:
	kind delete cluster --name shinypothos

refresh-cluster: destroy-cluster create-cluster

POSTGRES_POD_NAME = $(shell kubectl -n db get pods | grep db | awk '{ print $$1 }')
psql:
	kubectl exec -n db -it $(POSTGRES_POD_NAME) -- psql -h localhost -U admin -d db

get-minio-secrets: get-minio-access-key get-minio-secret-key

get-minio-access-key:
	@printf "Access Key:    "
	@kubectl get secret minio-credentials -n minio -o jsonpath='{.data.accesskey}' | base64 -d
	@echo ""

get-minio-secret-key:
	@printf "Secret Key:    "
	@kubectl get secret minio-credentials -n minio -o jsonpath='{.data.secretkey}' | base64 -d
	@echo ""