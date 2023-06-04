
resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  depends_on = [kubernetes_namespace.traefik]

  name       = "traefik"
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  chart      = "traefik"
  version    = "23.0.1"
  repository = "https://helm.traefik.io/traefik"

  set {
    name  = "ports.web.redirectTo"
    value = "websecure"
  }
  set {
    name  = "ports.websecure.tls"
    value = "true"
  }
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

