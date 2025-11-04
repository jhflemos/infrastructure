// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_lb" "app_alb" {
  internal           = false
  load_balancer_type = "application"
  name               = "prod-app-alb"
  security_groups = [
    aws_security_group.alb_sg.id,
  ]
  subnets = module.vpc.public_subnets
}
resource "aws_lb_target_group" "ecs_tg" {
  name     = "prod-ecs-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    type             = "forward"
  }
}
