resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.internet_facing_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nextjs_tg.arn
  }
}
