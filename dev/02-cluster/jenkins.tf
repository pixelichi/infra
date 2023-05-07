
# Full Jenkins Deployment
module "jenkins" {
  source           = "../../modules/jenkins"
  cluster_endpoint = digitalocean_kubernetes_cluster.cluster.endpoint
  cluster_token    = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  cluster_ca_cert = base64decode(
    digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}
