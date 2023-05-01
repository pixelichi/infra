# https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-kubernetes 

resource "kubernetes_namespace" "jenkins-main" {
  metadata {
    name = "jenkins-main"
  }
}


resource "kubernetes_persistent_volume_claim" "jenkins-pvc" {
  metadata {
    name      = "jenkins-main-deployment-pvc"
    namespace = kubernetes_namespace.jenkins-main.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = kubernetes_storage_class.do-block-retain-storage-class.metadata[0].name
  }
}


resource "kubernetes_deployment" "jenkins_deployment" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins-main.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        container {
          image             = "jenkins/jenkins:lts"
          image_pull_policy = "Always"
          name              = "jenkins"

          port {
            container_port = 8080
            name           = "http-port"
          }

          port {
            container_port = 50000
            name           = "jnlp-port"
          }

          volume_mount {
            mount_path = "/var/jenkins_vol"
            name       = "jenkins-vol"
          }
        }

        volume {
          name = "jenkins-vol"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins-pvc.metadata[0].name
            read_only  = false
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "jenkins_jnlp_service" {

  metadata {
    name      = "jenkins-jnlp"
    namespace = kubernetes_namespace.jenkins-main.metadata.0.name
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "jenkins"
    }

    port {
      port        = 50000
      target_port = 50000
    }
  }
}



resource "kubernetes_service" "jenkins_main_service" {

  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins-main.metadata.0.name
  }

  spec {
    cluster_ip = "None"
    selector = {
      app = "jenkins"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }
}
