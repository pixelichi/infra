#!/bin/bash

# Function to delete PVCs in all namespaces
delete_pvc() {
    echo "Deleting all PVCs in all namespaces..."
    kubectl get pvc --all-namespaces -o custom-columns=:.metadata.name,':.metadata.namespace' | tail -n +2 | while read pvc namespace; do
        kubectl delete pvc "$pvc" --namespace "$namespace"
    done
}

# Main execution
delete_pvc
