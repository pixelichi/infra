#!/bin/bash -e

install_k3s() {
    curl -sfL https://get.k3s.io | sh -
}

setup_node() {
    # This folder is needed in order to server files mounted from local computer
    sudo mkdir -p /usr/local/srv

    sudo mkdir -p /usr/local/srv/object
    sudo mkdir -p /usr/local/srv/ui
    sudo mkdir -p /usr/local/srv/vault
    sudo mkdir -p /usr/local/srv/db

    # Vault needs it's non-root user to be able to make changes to this directory
    # Found out the user UID:GID by exec'ing into the vault container and running `id` command
    sudo chown -R 100:1000 /usr/local/srv/vault
    sudo chmod -R 700 /usr/local/srv/vault
}

setup_node
install_k3s
