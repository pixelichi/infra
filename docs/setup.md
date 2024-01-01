### On using AWS to terraform changes

### Do aws configure 
You can use the access key and secret token from the available terraform user in the IAM console.

### Regions for this project
This project uses us-east-2, this is important since lightsail is not available in certain regions.

## ENV Variables
If you want to have your local kubectl piggy back off of the kubeconfig fetching that `./tf` does you can
add the following export to your zshrc script

```bash
export KUBECONFIG="$HOME/kube/prod-00/config"
```