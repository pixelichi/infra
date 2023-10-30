# resource "kubernetes_service" "jenkins_jnlp_service" {

#   metadata {
#     name      = "jenkins-jnlp"
#     namespace = kubernetes_namespace.jenkins-main.metadata.0.name
#   }

#   spec {
#     type = "ClusterIP"

#     selector = {
#       app = "jenkins"
#     }

#     port {
#       port        = 50000
#       target_port = 50000
#     }
#   }

#   depends_on = [kubernetes_deployment.jenkins_main_deployment]
# }
