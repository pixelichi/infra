#!/bin/bash -e

# Assumes ubuntu

# Check if socat is installed - Needed for trafic routing
if ! command -v socat &>/dev/null; then
  echo "socat not found, installing..."
  sudo apt install socat -y
else
  echo "socat is already installed."
fi

# install kind cluster...
if ! command -v kind &>/dev/null; then
  echo "kind not found, installing..."

  # For AMD64 / x86_64
  [ "$(uname -m)" = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
  # For ARM64
  [ "$(uname -m)" = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
else
  echo "kind is already installed."
fi

if ! command -v vault &>/dev/null; then
  # From https://www.hashicorp.com/official-packaging-guide?ajs_aid=db5f537d-f6f7-4f8f-ae9f-a9262267bb02&product_intent=vault
  echo "vault not found, installing..."
  sudo apt update -y && sudo apt install gpg -y
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update -y
  sudo apt install vault -y
else
  echo "vault is already installed."
fi
