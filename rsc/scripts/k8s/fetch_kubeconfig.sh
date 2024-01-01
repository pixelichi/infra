#!/bin/bash -e

# Function to display usage
usage() {
    echo "Usage: $0 [remote_user] [remote_host] [ssh_key_path] [kubeconfig_path] [new_ip]"
    exit 1
}

# Check for correct number of arguments
if [ "$#" -ne 5 ]; then
    usage
fi

# Assign arguments to variables
REMOTE_USER="$1"
REMOTE_HOST="$2"
REMOTE_KEY="$3"
KUBECONFIG_PATH="$4"
NEW_IP="$5"

# Fetch kubeconfig from remote Kubernetes cluster
fetch_kubeconfig() {
    mkdir -p "$(dirname "$KUBECONFIG_PATH")"
    echo "Fetching kubeconfig from remote Kubernetes cluster..."
    ssh -o StrictHostKeyChecking=no -i "${REMOTE_KEY}" "${REMOTE_USER}@${REMOTE_HOST}" "sudo cat /etc/rancher/k3s/k3s.yaml" >"${KUBECONFIG_PATH}"
}

# Update kubeconfig with the desired server IP
update_kubeconfig_server_ip() {
    echo "Updating kubeconfig server IP to ${NEW_IP}..."
    sed -i '' "s|server:.*|server: https://${NEW_IP}:6443|g" "${KUBECONFIG_PATH}"
}

# Main function
main() {
    fetch_kubeconfig
    update_kubeconfig_server_ip
    echo "kubeconfig updated successfully."
}

# Execute main function
main
printf "\n\n"
