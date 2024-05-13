# Private Route Table per AZ
resource "aws_route_table" "private_route_table" {
  count  = length(module.vpc.private_subnets)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.name}-private-route-table-${count.index + 1}"
  }
}

# Private Route Table Entry for each NAT Gateway
resource "aws_route" "private_route" {
  count                = length(module.vpc.private_subnets)
  route_table_id       = element(aws_route_table.private_route_table[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"  # All outbound traffic
  nat_gateway_id       = element(aws_nat_gateway.nat_gw[*].id, count.index)
}