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
}
