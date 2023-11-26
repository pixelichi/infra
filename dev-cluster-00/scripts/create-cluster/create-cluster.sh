#!/bin/bash -e

RSC_DIR="$(pwd)/scripts/create-cluster/rsc"

verify_arguments() {
  if [ $# -ne 1 ]; then
    printf "create-cluster.sh - Failure, missing required parameter - create-cluster.sh cluster-name"
  fi
}

create_cluster() {
  # This folder is needed in order to server files mounted from local computer
  if ! test -d /usr/local/srv; then
    sudo mkdir -p /usr/local/srv
  fi

  local cluster_name="$1"

  # Check if the cluster already exists
  if kind get clusters | grep -q "^$cluster_name\$"; then
    echo "Cluster $cluster_name already exists, skipping creation."
  else
    kind create cluster --config="$RSC_DIR/kind-cluster-config.yaml" --name "$cluster_name" --wait 5m
  fi
}

setup_terraform_kubernetes_config() {
  kubectl apply -f "$RSC_DIR/terraform_namespace.yaml"
  kubectl apply -f "$RSC_DIR/cluster_role_binding.yaml"
}

verify_arguments "$@"
create_cluster "$@"
setup_terraform_kubernetes_config
