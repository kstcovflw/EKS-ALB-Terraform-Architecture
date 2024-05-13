# Resource: Kubernetes Namespace ns-app1
resource "kubernetes_namespace" "ns_nextjs" {
  metadata {
    name = "ns-nextjs"
  }
}

# Resource: Kubernetes Namespace ns-app2
resource "kubernetes_namespace" "ns_redis" {
  metadata {
    name = "ns-redis"
  }
}

variable "nextjs_docker_app_name" {
  description = "The application name label for the Next.js deployment."
  default     = "nextjs-app"
}