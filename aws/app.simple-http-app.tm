
generate_hcl "_auto_generated_app.simple-http-app.tf" {
  content {

    locals {
     app_name = "simple-http-app"
    }

    module "simple-http-app" {
      source = "../../vendor/modules/terraform-modules/applications/simple-http-app"

      app_name = local.app_name

      environment = global.environment

      alb_arn   = aws_lb.app_alb.arn
      alb_sg_id = aws_security_group.alb_sg.id

      vpc_id = module.vpc.vpc_id

      private_subnets = module.vpc.private_subnets

      env_vars = [
       {
         name = "environment"
         value = "${global.environment}"
        }
      ]

      tags = {
        TF_Module   = "terraform-modules/applications/simple-http-app"
        Name        = local.app_name
        Environment = global.environment
      }
    }
  }
}
