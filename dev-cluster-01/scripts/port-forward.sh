#!/bin/bash -e
#!/bin/bash -e

proxy_service() {
    # Parameter count validation
    if [ "$#" -ne 4 ]; then
        echo "Usage: proxy_service <namespace> <service_name> <local_port> <remote_port>"
        exit 1
    fi

    local namespace="$1"
    local service_name="$2"
    local local_port="$3"
    local remote_port="$4"

    # Validate namespace and service name (basic validation for non-empty strings)
    if [ -z "$namespace" ] || [ -z "$service_name" ]; then
        echo "Namespace and service name must be provided."
        exit 1
    fi

    # Validate local and remote ports (check if they are integers)
    if ! [[ "$local_port" =~ ^[0-9]+$ ]] || ! [[ "$remote_port" =~ ^[0-9]+$ ]]; then
        echo "Local and remote ports must be valid integers."
        exit 1
    fi

    # Check if the service exists
    if ! kubectl -n "$namespace" get service "$service_name" &>/dev/null; then
        echo "Service $service_name does not exist in namespace $namespace."
        exit 1
    fi

    # Clean up any existing process using the local port
    echo "Cleaning up any processes using local port $local_port..."
    lsof -i :"$local_port" | awk 'NR>1 {print $2}' | xargs -r kill -9

    # Forward port
    echo "Proxying the $service_name..."
    kubectl -n "$namespace" port-forward service/"$service_name" "$local_port":"$remote_port" --address 0.0.0.0 1>/dev/null &
    sleep 3 && echo "Now proxying $service_name on port $local_port."
}

proxy_service "$@"
