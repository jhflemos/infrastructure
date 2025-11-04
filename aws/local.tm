generate_hcl "_auto_generated_local.tf" {
  content {
    locals {
      applications = [
        "application-1",
        "application-2"
      ]
    }
  }
}
