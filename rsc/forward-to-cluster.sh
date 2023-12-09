#!/bin/bash

# NGINX
socat TCP-LISTEN:80,fork TCP:172.18.0.2:30000 &

# API SERVER
socat TCP-LISTEN:1337,fork TCP:172.18.0.2:31000 &

# DB
socat TCP-LISTEN:5432,fork TCP:172.18.0.2:32000 &

# CloudFlare Tunnel
docker run -d --network "host" cloudflare/cloudflared:latest tunnel --no-autoupdate run --token <TOKEN_HERE_GETI_IT_FROM_CLOUD_FLARE_PANEL>
