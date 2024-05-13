module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  name    = "${var.stage}-${var.name}-vpc"
  cidr    = var.vpc_cidr

  azs = var.azs
  private_subnets     = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]



  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = true
  map_public_ip_on_launch = true
  one_nat_gateway_per_az  = true


  tags = {
    Terraform   = "true"
    Environment = "${var.stage}"
    
  }
}
