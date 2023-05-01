CLUSTER_ID ?= ""

add-kubeconfig:
	doctl kubernetes cluster kubeconfig save $(CLUSTER_ID)

registry-login:
	doctl registry login

registry-login-docker:
	docker login registry.digitalocean.com