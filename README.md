# Local Setup

Please run ./rsc/baremetal/setup.sh to get your local setup up to speed.

# Dev Cluster

This is my ncase desktop which runs ubuntu. It is running a kind cluster on x86/64bit.
The way the server is exposed to the public internet is through cloudflare tunnels.

Run `rsc/baremetal/setup.sh` to run necessary installs on the server.

## Crontab

@reboot /usr/local/sbin/forward-to-cluster.sh

^ That script can be found in `rsc/baremetal/forward-to-cluster.sh`, the cloudflare token needs to be manually placed there.
