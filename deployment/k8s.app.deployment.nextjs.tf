resource "kubernetes_deployment" "nextjs_deployment" {
  metadata {
    name      = "${var.stage}-nextjs-app"
    namespace = "ns-nextjs" # Correct namespace name
    annotations = {
      "nextjs-docker-image" = var.nextjs_docker_image
    }
  }

  spec {
    replicas = 2 # var.nextjs_replica_count
    selector {
      match_labels = {
        app = var.nextjs_docker_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.nextjs_docker_app_name
        }
      }

      spec {
        container {
          image = var.nextjs_docker_image
          name  = var.nextjs_docker_app_name

          port {
            container_port = var.nextjs_container_port
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = var.nextjs_container_port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.nextjs_container_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
        }
      }
    }
  }
  depends_on = [
    module.eks,
    kubernetes_service.nextjs_service
  ]

}
