#!/bin/bash

stop_proxy_vault() {
  lsof -i :8200 | awk 'NR>1 {print $$2}' | xargs -r kill -9
  lsof -i :8201 | awk 'NR>1 {print $$2}' | xargs -r kill -9
  sleep 3
}

stop_proxy_vault
