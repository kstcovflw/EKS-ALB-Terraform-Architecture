resource "aws_lb_target_group" "nextjs_tg" {
  name        = "${var.name}-nextjs-tg"
  target_type = "instance"  # Or "ip" if targeting pods directly in EKS
  port        = var.nextjs_container_port  # This should be 3000 as per your application setup
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"  # Confirm this path responds with HTTP 200 on your app
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}
