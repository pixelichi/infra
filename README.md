# Local Setup

Please run ./rsc/baremetal/setup.sh to get your local setup up to speed.

# Dev Cluster

This is my ncase desktop which runs ubuntu. It is running a kind cluster on x86/64bit.
The way the server is exposed to the public internet is through cloudflare tunnels.

Run `rsc/baremetal/setup.sh` to run necessary installs on the server.

## Crontab

You can add a cron job to your ubuntu machine by running the following:

```bash

# Crontab for root user
sudo su

# Make sure the script you want to run is executable
chmod +x /path/to/your/script.sh

# Edit the crontab file and add your new line
crontab -e

# Example of something that runs every 5 minutes
# */5 * * * * /path/to/your/script.sh

# After adding you can verify contrab here
crontab -l
```

Example crontab file:

```
*/1 * * * * /usr/local/sbin/ensure-cloudflared.sh >> /tmp/cron-ensure-cloudflared-logs 2>&1
@reboot /usr/local/sbin/forward-to-cluster.sh >> /tmp/cron-forward-to-cluster-logs 2>&1
```

^ That script can be found in `rsc/baremetal/forward-to-cluster.sh`, the cloudflare token needs to be manually placed there.


# Current State
We can now deploy a cluster, deploy vault in that cluster, configure vault, manually add secrets at specific locations where deployments expect them, then go ahead and deploy.
Vault and Minio have persistence accross cluster restarts / destroys, we are now deploying static assets service and minio. The real passwords for things are kept offline in a password manager, not too bad since there is only one manual step to enter those into vault inside of /secrets/terraform/*.

Next we need to deploy the Database with a good appropriate password and username, as well as deploying the backend service. After that we an play around with a suitable enough prod...
May be good to look at ssl, but besides that, not too shaby!