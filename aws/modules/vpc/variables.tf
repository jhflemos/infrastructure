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
}

variable "private_subnets" {
  description = "List of private subnets with CIDR block and AZ"
  type = list(object({
    cidr_block         = string
    availability_zone  = string
  }))
}
