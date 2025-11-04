provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform-Managed = "true"
    }
  }
}
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "study-terraform-state-bucket"
    key    = "aws/env/${var.environment}/terraform.tfstate"
    region = var.region
  }
}
