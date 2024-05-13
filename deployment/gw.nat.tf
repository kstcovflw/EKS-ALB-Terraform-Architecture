# Variable definition
variable "one_nat_gateway" {
  description = "Set to true if only one NAT Gateway is required"
  type        = bool
  default     = true
}

# Allocate Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip" {
  count  = var.one_nat_gateway ? 1 : length(module.vpc.public_subnets)
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip-${count.index + 1}"
  }
}

# NAT Gateway for each AZ's public subnet
resource "aws_nat_gateway" "nat_gw" {
  count         = var.one_nat_gateway ? 1 : length(module.vpc.public_subnets)
  allocation_id = element(aws_eip.nat_eip[*].id, count.index)
  subnet_id     = element(module.vpc.public_subnets, count.index)
  tags = {
    Name = "${var.name}-nat-gateway-${count.index + 1}"
  }
}

