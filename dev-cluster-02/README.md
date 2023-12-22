# dev-cluster-01

This terraform code is meant to deploy additional resources on top of the dev-cluster-00 deployment. Whereas 00 was about foundational items, this cluser (01) is about resources that are used by the product itself and rely on the foundational resources from 00. The current example of resources in 00 is Vault, while this cluster contains things like DB / nginx / backend / minio.

# Local Setup

Please see the readme within dev-cluster-00.

## Crontab

@reboot /usr/local/sbin/forward-to-cluster.sh
^ That script can be found in `rsc/baremetal/forward-to-cluster.sh`, the cloudflare token needs to be manually placed there.
