
generate_hcl "_auto_generated_app.simple-http-app.tf" {
  content {

    locals {
      simple_http_app_name = "simple-http-app"
    }

    module "simple-http-app" {
      source = "../../vendor/modules/terraform-modules/applications/simple-http-app"

      app_name = local.simple_http_app_name

      environment = global.environment

      api = false

      alb = {
        alb_arn          = aws_lb.app_alb.arn
        alb_dns_name     = aws_lb.app_alb.dns_name
        alb_sg_id        = aws_security_group.alb_sg.id
        route53_cert_arn = aws_acm_certificate_validation.root[0].certificate_arn
        health_check = {
          path                = "/"
          interval            = 30
          timeout             = 5
          healthy_threshold   = 2
          unhealthy_threshold = 2
          matcher             = "200-399"
        }
        listener = {
          priority  = 100
          condition = [
            {
              path_pattern = {
                values = ["/", "/greet/*"]
              }
            }
          ]
        }
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
        TF_Module = "terraform-modules/applications/simple-http-app"
        Name      = local.simple_http_app_name
      }
    }
  }
}
