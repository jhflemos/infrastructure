generate_hcl "_auto_generated_provider.tf" {
  content {
    provider "aws" {
      region = global.region

      default_tags {
        tags = {
          Terraform-Managed = "true"
        }
      }
    }
    terraform {
      required_version = ">= 1.5.0"
    }
  }
}
