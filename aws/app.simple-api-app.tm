
generate_hcl "_auto_generated_app.simple-api-app.tf" {
  content {

    locals {
     simple_api_app_name = "simple-api-app"
    }

    module "simple-api-app" {
      source = "../../vendor/modules/terraform-modules/applications/simple-api-app"

      app_name = local.simple_api_app_name

      environment = global.environment

      api_gateway = true

      alb = {
        listener_arn = aws_lb_listener.https.arn
        alb_dns_name = aws_lb.app_alb.dns_name
        alb_sg_id    = aws_security_group.alb_sg.id
        health_check = {
          path                = "/api/health"
          interval            = 30
          timeout             = 5
          healthy_threshold   = 2
          unhealthy_threshold = 2
          matcher             = "200-399"
        }
        listener = {}
      }

      vpc_id = module.vpc.vpc_id

      private_subnets = module.vpc.private_subnets

      env_vars = [
       {
         name  = "environment"
         value = "${global.environment}"
        }
      ]

      ssm_parameters = [
       {
         name = "SECRET_FROM_SSM"
       }
      ]

      tags = {
        TF_Module = "terraform-modules/applications/simple-api-app"
        Name      = local.simple_api_app_name
      }
    }
  }
}
