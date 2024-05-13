# Terraform Settings Block
terraform {
  required_version = ">= 1.8.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4"
    }
    kubernetes = {
      source  = "registry.terraform.io/hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.3.0"
    }

  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "your-unique-bucket-name-tfstate" # use the same value in ready/_variables.tf > project_bucket_name project_bucket_name
    key    = "dev/aws-lbc-ingress/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "dev-aws-lbc-ingress"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
