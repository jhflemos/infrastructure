// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "vpc" {
  aws_region  = "eu-west-1"
  environment = "prod"
  source      = "./modules/vpc"
  tags = {
    Environment = "prod"
  }
}
