#!/bin/bash -e

kubectl apply -f terraform_namespace.yaml
kubectl apply -f service_account.yaml
kubectl apply -f cluster_role_binding.yaml
