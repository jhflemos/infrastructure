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

    resource "aws_lb" "app_nlb_api" {
      name               = "${global.environment}-app-nlb-api"
      internal           = true
      load_balancer_type = "network"
      subnets            = module.vpc.private_subnets

      tags = { 
        Name = "${global.environment}-app-nlb-api" 
      }
    }

  }
}
