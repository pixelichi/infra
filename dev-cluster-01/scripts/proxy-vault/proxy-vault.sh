#!/bin/bash

proxy_vault() {
  kubectl -n vault port-forward service/vault 8200:8200 1>/dev/null &
  kubectl -n vault port-forward service/vault 8201:8201 1>/dev/null &
  sleep 3
}

proxy_vault
