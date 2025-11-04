
generate_hcl "_auto_generated_app.simple-http-app.tf" {
  content {

    locals {
     app_name = "simple-http-app"
    }

    module "simple-http-app" {
      source = "../../vendor/modules/terraform-modules/applications/simple-http-app"

      app_name = local.app_name

      environment = global.environment

      tags = {
        TF_Module   = "terraform-modules/applications/simple-http-app"
        Name        = local.app_name
        Environment = global.environment
      }
    }
  }
}
