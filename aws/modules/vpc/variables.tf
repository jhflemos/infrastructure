variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "Environment which the module is being currently run in i.e. dev or prod"
}

variable "public_subnets" {
  description = "List of public subnets with CIDR block and AZ"
  type = list(object({
    cidr_block         = string
    availability_zone  = string
  }))
  default = [
    { cidr_block = "10.0.1.0/24", availability_zone = data.aws_availability_zones.available.names[0] },
    { cidr_block = "10.0.2.0/24", availability_zone = data.aws_availability_zones.available.names[1] },
    { cidr_block = "10.0.3.0/24", availability_zone = data.aws_availability_zones.available.names[2] }
  ]
}

variable "private_subnets" {
  description = "List of private subnets with CIDR block and AZ"
  type = list(object({
    cidr_block         = string
    availability_zone  = string
  }))
  default = [
    { cidr_block = "10.0.101.0/24", availability_zone = data.aws_availability_zones.available.names[0] },
    { cidr_block = "10.0.102.0/24", availability_zone = data.aws_availability_zones.available.names[1] },
    { cidr_block = "10.0.103.0/24", availability_zone = data.aws_availability_zones.available.names[2] }
  ]
}
