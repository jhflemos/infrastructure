generate_hcl "_auto_generated_vpc.tf" {
  content {
    module "vpc" {
      source = "../modules/vpc"

      aws_region  = global.region
      environment = global.environment

      tags = {
       Environment = global.environment
      }
    }
  }
}
