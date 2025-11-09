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
      internal           = false
      load_balancer_type = "application"
      security_groups    = [aws_security_group.alb_sg.id]
      subnets            = module.vpc.private_subnets

      tags = { 
        Name = "${global.environment}-app-alb-api" 
      }
    }

    resource "aws_lb_listener" "https" {
      count = global.route53 ? 1 : 0

      load_balancer_arn = aws_lb.app_alb.arn
      port              = 443
      protocol          = "HTTPS"
      certificate_arn   = aws_acm_certificate_validation.root[0].certificate_arn

      default_action {
        type = "fixed-response"
        fixed_response {
          content_type = "text/plain"
          message_body = "No matching path"
          status_code = 404
        }
      }

      tags = {
        Name = "${global.environment}-lb-listener-https"
      }
    }

    resource "aws_lb_listener" "https-api" {
      count = global.route53 ? 1 : 0

      load_balancer_arn = aws_lb.app_alb_api.arn
      port              = 443
      protocol          = "HTTPS"
      certificate_arn   = aws_acm_certificate_validation.root[0].certificate_arn

      default_action {
        type = "fixed-response"
        fixed_response {
          content_type = "text/plain"
          message_body = "No matching path"
          status_code = 404
        }
      }

      tags = {
        Name = "${global.environment}-lb-listener-https-api"
      }
    }

    resource "aws_lb_listener" "http" {
      load_balancer_arn = aws_lb.app_alb.arn
      port              = 80
      protocol          = "HTTP"

      dynamic "default_action" {
        for_each = [1]
        content {
          type = global.route53 ? "redirect" : "fixed-response"

          redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }

          fixed_response {
            content_type = "text/plain"
            message_body = "No matching path"
            status_code  = 404
          }
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

      dynamic "default_action" {
        for_each = [1]
        content {
          type = global.route53 ? "redirect" : "fixed-response"

          redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }

          fixed_response {
            content_type = "text/plain"
            message_body = "No matching path"
            status_code  = 404
          }
        }
      }
      
      tags = {
        Name = "${global.environment}-lb-listener-http-api"
      }
    }
  }
}
