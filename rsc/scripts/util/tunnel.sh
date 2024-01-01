#!/bin/bash -e

# Function to print usage information
usage() {
    echo "Usage: $0 -u [remote_user] -h [remote_host] -i [identity_file] -l [local_port] -r [remote_port]"
    echo "  -u  Remote SSH user"
    echo "  -h  Remote host address"
    echo "  -i  Identity file (private key), optional"
    echo "  -l  Local port"
    echo "  -r  Remote port"
    exit 1
}

# Function to parse arguments
parse_args() {
    while getopts ":u:h:i:l:r:" opt; do
        case $opt in
        u) REMOTE_USER=$OPTARG ;;
        h) REMOTE_HOST=$OPTARG ;;
        i) IDENTITY_FILE=$OPTARG ;;
        l) LOCAL_PORT=$OPTARG ;;
        r) REMOTE_PORT=$OPTARG ;;
        *) usage ;;
        esac
    done

    # Check required arguments
    if [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_HOST" ] || [ -z "$LOCAL_PORT" ] || [ -z "$REMOTE_PORT" ]; then
        printf "\n\n\e[31m%s\e[0m\n\n" "Error! Not all requirement arguments were passed in!" >&2
        usage
    fi
}

# Function to set up SSH tunnel
setup_tunnel() {

    # Clean up any existing process using the local port
    echo "Cleaning up any processes using local port $LOCAL_PORT..."
    lsof -i :"$LOCAL_PORT" | awk 'NR>1 {print $2}' | xargs -r kill -9

    local ssh_cmd="ssh -o StrictHostKeyChecking=no -N -L ${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST}"

    # Add identity file to SSH command if provided
    if [ ! -z "$IDENTITY_FILE" ]; then
        ssh_cmd+=" -i ${IDENTITY_FILE}"
    fi

    # Run SSH command in the background
    echo "Setting up SSH tunnel..."
    nohup $ssh_cmd >/dev/null 2>&1 &
    echo "Tunnel established."
}

# Main function
main() {
    parse_args "$@"
    setup_tunnel
}

# Run the main function with all arguments passed to the script
main "$@"
printf "\n\n"
