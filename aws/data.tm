generate_hcl "_auto_generated_data.tf" {
  content {
    data "aws_availability_zones" "available" {
      state = "available"
    }
  }
}
