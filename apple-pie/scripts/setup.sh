#!/bin/bash -xe

# This setup script is meant to setup the raspberry pi from scratch

# 1. Install k3s
echo "Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Download and install k3s
echo "Installing k3s..."
curl -sfL https://get.k3s.io | sh -

# Check if k3s is installed successfully
if systemctl is-active --quiet k3s; then
    echo "k3s installed successfully."
else
    echo "There was an issue installing k3s."
fi

# Enable k3s service to start on boot
echo "Enabling k3s to start on boot..."
sudo systemctl enable k3s

# Output the status of k3s
echo "k3s service status:"
sudo systemctl status k3s

# Ability to run kubectl commands as non-root
sudo chown "$(whoami)" /etc/rancher/k3s/k3s.yaml

# 2. Make kubectl commands a bit more comfy
sudo apt install bash-completion
{
    echo 'alias kc=kubectl'
    echo 'source <(kubectl completion bash)'
    echo 'complete -F __start_kubectl kc'
} >>~/.bashrc

# shellcheck source=/dev/null
source "$HOME/.bashrc"
