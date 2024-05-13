# security_group listening traffic from alb nextjs_container_port
# Security Group for EKS Nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.stage}-eks-nodes-sg"
  description = "Security group for EKS Nodes"
  vpc_id      = module.vpc.vpc_id

  # Allow inbound traffic from the ALB to the application port (3000)
  ingress {
    from_port       = 80                        # Should be the port that the ALB sends traffic to, typically 3000 if that's where your app listens
    to_port         = var.nextjs_container_port # The port your Next.js app is listening on
    protocol        = "tcp"
    security_groups = [aws_security_group.internet_facing_alb_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stage}-eks-nodes-sg"
  }
}

