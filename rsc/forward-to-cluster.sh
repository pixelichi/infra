#!/bin/bash

# The following are for lan development, this way we can reach out to the machine and get redirected to the service
# running within the cluster

# NGINX
socat TCP-LISTEN:80,fork TCP:172.18.0.2:30000 &

# API SERVER
socat TCP-LISTEN:1337,fork TCP:172.18.0.2:31000 &

# DB
socat TCP-LISTEN:5432,fork TCP:172.18.0.2:32000 &

# SSH
socat TCP-LISTEN:5432,fork TCP:172.18.0.2:32000 &

# CloudFlare Tunnel - This is what actually ties you to the public internet
docker run -d --network "host" cloudflare/cloudflared:latest tunnel --no-autoupdate run --token <TOKEN_HERE_GET_IT_FROM_CLOUD_FLARE_PANEL>
