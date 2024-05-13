resource "kubernetes_service" "nextjs_service" {
  metadata {
    name      = "nextjs-service"
    namespace = "ns-nextjs"  # Correct namespace name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                 = "alb"
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"     = "http"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-path"     = "/"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-port"     = 80
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval" = 30
      "service.beta.kubernetes.io/aws-load-balancer-target-group-arn" = aws_lb_target_group.nextjs_tg.arn
    }
  }

  spec {
    selector = {
      app = var.nextjs_docker_app_name
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = var.nextjs_container_port
    }

    # Uncomment below for SSL
    # port {
    #   protocol    = "TCP"
    #   port        = 443
    #   target_port = var.nextjs_container_port
    #   }

    type = "LoadBalancer"
  }
  depends_on = [module.eks]
}