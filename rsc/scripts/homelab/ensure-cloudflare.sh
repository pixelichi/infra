#!/bin/bash

# Check if the Docker daemon is running
if ! systemctl is-active --quiet docker; then
  echo "Docker is not running. Attempting to start Docker..."
  sudo systemctl start docker

  # Wait for a moment to let Docker daemon start
  sleep 5

  # Check again if Docker has started
  if ! systemctl is-active --quiet docker; then
    echo "Failed to start Docker. Please check the system manually."
    exit 1
  else
    echo "Docker started successfully."
  fi
fi

# Check if the container with the specified image is running
container_id=$(docker ps --filter "ancestor=cloudflare/cloudflared:latest" --format "{{.ID}}")

if [ -z "$container_id" ]; then
  echo "Container with image 'cloudflare/cloudflared:latest' is not running. Restarting the container..."
  docker run -d --network "host" cloudflare/cloudflared:latest tunnel --no-autoupdate run --token <TOKEN HERE FROM CLOUDFLARE CONSOLE>
fi
