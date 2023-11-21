#!/bin/bash -e

# Code is meant to retrieve the kubeconfig from the apple pie server which runs k3s

validate_args() {
    if [[ "$#" -ne 3 ]]; then
        printf "3 Arguments required. (username, host , output_location)\n"
        exit 1
    fi
}

get_kubeconfig() {
    local HOST="$2"
    local USER="$1"
    local LOCAL_KUBECONFIG_PATH="$3"

    scp "$USER@$HOST:/etc/rancher/k3s/k3s.yaml" "$LOCAL_KUBECONFIG_PATH" 1>/dev/null

    # Check OS and use appropriate sed command
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: use an extension for backup, and then remove the backup file
        sed -i '.bak' "s/127.0.0.1/$HOST/g" "$LOCAL_KUBECONFIG_PATH"
        rm -f "${LOCAL_KUBECONFIG_PATH}.bak"
    else
        # Linux: no backup file is created
        sed -i "s/127.0.0.1/$HOST/g" "$LOCAL_KUBECONFIG_PATH"
    fi

    echo "Run 'export KUBECONFIG=$LOCAL_KUBECONFIG_PATH' to set up your KUBECONFIG environment variable."
}

validate_args "$@"
get_kubeconfig "$@"
