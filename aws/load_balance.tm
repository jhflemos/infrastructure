generate_hcl "_auto_generated_load_balance.tf" {
  content {
    resource "aws_lb" "app_alb" {
      name               = "${global.environment}-app-alb"
      internal           = false
      load_balancer_type = "application"
      security_groups    = [aws_security_group.alb_sg.id]
      subnets            = module.vpc.public_subnets

      tags = { 
        Name = "${global.environment}-app-alb" 
      }
    }

    resource "aws_lb" "app_alb_api" {
      name               = "${global.environment}-app-alb-api"
      internal           = true
      load_balancer_type = "application"
      security_groups    = [aws_security_group.alb_sg.id]
      subnets            = module.vpc.private_subnets

      tags = { 
        Name = "${global.environment}-app-alb-api" 
      }
    }

    resource "aws_lb_listener" "http" {
      load_balancer_arn = aws_lb.app_alb.arn
      port              = 80
      protocol          = "HTTP"

      default_action {
        type = "fixed-response"
        fixed_response {
          content_type = "text/plain"
          message_body = "No matching path"
          status_code = 404
        }
      }

      tags = {
        Name = "${global.environment}-lb-listener-http"
      }
    }

    resource "aws_lb_listener" "http_api" {
      load_balancer_arn = aws_lb.app_alb_api.arn
      port              = 80
      protocol          = "HTTP"

      default_action {
        type = "fixed-response"
        fixed_response {
          content_type = "text/plain"
          message_body = "No matching path"
          status_code = 404
        }
      }

      tags = {
        Name = "${global.environment}-lb-listener-http-api"
      }
    }

    resource "aws_lb" "app_nlb_api" {
      name               = "${global.environment}-app-nlb-api"
      internal           = true
      load_balancer_type = "network"
      subnets            = module.vpc.private_subnets

      tags = { 
        Name = "${global.environment}-app-nlb-api" 
      }
    }

    resource "aws_lb_target_group" "nlb_to_alb" {
      name        = "${global.environment}-nlb-tg"
      port        = 80
      protocol    = "TCP"
      vpc_id      = module.vpc.vpc_id
      target_type = "ip"
    }

    resource "aws_lb_listener" "nlb_listener" {
      load_balancer_arn = aws_lb.app_nlb_api.arn
      port              = 80
      protocol          = "TCP"

      default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.nlb_to_alb.arn
      }
    }
    
  }
}
