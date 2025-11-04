
module "vpc" {
  source = "../../modules/infrastructure/vpc"

  aws_region  = var.aws_region
  environment = var.environment

  public_subnets = [
    { cidr_block = "10.0.1.0/24", availability_zone = data.aws_availability_zones.available.names[0] },
    { cidr_block = "10.0.2.0/24", availability_zone = data.aws_availability_zones.available.names[1] },
    { cidr_block = "10.0.3.0/24", availability_zone = data.aws_availability_zones.available.names[2] }
  ]

  private_subnets = [
    { cidr_block = "10.0.101.0/24", availability_zone = data.aws_availability_zones.available.names[0] },
    { cidr_block = "10.0.102.0/24", availability_zone = data.aws_availability_zones.available.names[1] },
    { cidr_block = "10.0.103.0/24", availability_zone = data.aws_availability_zones.available.names[2] }
  ]

  tags = {
    Environment = var.environment
  }
}

