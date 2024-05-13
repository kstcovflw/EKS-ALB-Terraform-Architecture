#  internet-facing ALB (Public subnets)
resource "aws_lb" "internet_facing_alb" {
  name               = "internet-facing-alb"

  # When internal is set to false, the ALB will be internet-facing.
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internet_facing_alb_sg.id]
  
  # ALB will be created in all specified public subnets
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = "${var.stage}"
  }
}