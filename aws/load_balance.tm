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

    resource "aws_lb_listener" "https" {
      load_balancer_arn = aws_lb.app_alb.arn
      port              = 443
      protocol          = "HTTPS"
      certificate_arn   = global.route53 ? aws_acm_certificate_validation.root[0].certificate_arn : null

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

    resource "aws_lb_listener" "http" {
      load_balancer_arn = aws_lb.app_alb.arn
      port              = 80
      protocol          = "HTTP"

      default_action {
        type = "redirect"

        redirect {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }

      tags = {
        Name = "${global.environment}-lb-listener-http"
      }
    }
  }
}
