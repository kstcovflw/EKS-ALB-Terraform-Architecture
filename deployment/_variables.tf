variable "region" {
  default = "us-east-1"
}

variable "stage" {
  default = "dev"
}


variable "domain_name" {
  default = "custom-project.com"
}

variable "name" {
  default = "custom-project"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Nextjs related

variable "nextjs_container_port" {
  description = "The port that the Next.js application listens on inside the container."
  default     = 3000
}

variable "nextjs_docker_image" {
  description = "The Docker image for the Next.js application."
  // Replace with your actual image URL
  default     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/next-frontend"
}

variable "nextjs_docker_name" {
  description = "The Docker image for the Next.js application."
  // Replace with your actual image URL
  default     = "next-frontend"
}

