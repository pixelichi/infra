#!/bin/bash

# Function to delete PVs
delete_pv() {
    echo "Deleting all PVs..."
    kubectl get pv -o custom-columns=:.metadata.name | tail -n +2 | while read pv; do
        kubectl delete pv "$pv"
    done
}

# Main execution
delete_pv
