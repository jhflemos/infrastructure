generate_hcl "_auto_generated_alb.tf" {
  content {
    resource "aws_lb" "app_alb" {
      name               = "${global.environment}-app-alb"
      internal           = false
      load_balancer_type = "application"
      security_groups    = [aws_security_group.alb_sg.id]
      subnets            = module.vpc.public_subnets
    }
  }
}
