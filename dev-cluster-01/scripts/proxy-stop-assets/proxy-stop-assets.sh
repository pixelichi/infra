#!/bin/bash -e

# static asset service
printf "Stopping any open proxies on port 3000 for Static Asset Service..."
lsof -i :3000 | awk 'NR>1 {print $$2}' | xargs -r kill -9
printf "done!"
