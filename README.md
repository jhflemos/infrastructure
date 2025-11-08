# Infrastructure

This repository contains the infrastructure-as-code (IaC) using **Terraform**, **Terramate**, and **Terrafile**, targeting AWS resources. It is organized into reusable modules, applications, and workflows to automate provisioning, deployment, and management of cloud resources.

## Overview

This repository manages AWS infrastructure for applications such as `simple-api-app` and `simple-http-app`.  
It includes:

- ECS services, task definitions, and deployments.
- ALB and load balancers.
- VPCs, subnets, and security groups.
- Route53 DNS configuration.
- Integration with CI/CD pipelines via GitHub Actions.

**Terramate** is used for managing workspaces, dependencies, and modular Terraform execution.  
**Terrafile** is used to manage external Terraform module dependencies in `vendor/`.

---
## Prerequisites

- **Terraform** >= 1.5
- **Terramate** >= 0.14
- **Terrafile** >= 0.8
- **AWS CLI** with proper credentials
- **jq** (for JSON processing in workflows)
- GitHub secrets for CI/CD:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN` (if required)

---

## Getting Started

1. **Clone the repository**

```bash
git clone git@github.com:jhflemos/infrastructure.git
cd infrastructure/aws
```

2. **Install external modules using Terrafile**
```bash
terrafile -f terrafile
```
This will populate the vendor/ folder with external modules.

2. **Generate terraform file via Terramate**
```bash

# This command will generate the terraform files in env/ folder
terramate generate

# This command will generate the terrafoirm files for the application module
cd vendor/modules/terraform-modules/applications
terramate generate

# This command will generate the terrafoirm files for the functions module
cd vendor/modules/terraform-modules/functions
terramate generate

```
Within a **/env/dev** or **env/prod** folder:
```bash
terramate run plan
terramate run apply
terramate run destroy
```


## Terraform, Terramate & Terrafile

* Terramate workspaces (*.tm) allow isolated and reusable Terraform executions.
* Terrafile manages external Terraform module dependencies.
* Terraform variable files and environment overrides are in variables.tm and env/.
* External modules are automatically synced into the vendor/ folder.

## GitHub Actions Workflows

### Terraform Plan & Apply (terraform.yaml)
* Runs on pushes or pull requests to main.
* Performs:
  * Environment setup
  * Terraform and Terramate initialization
  * Terrafile import
  * Terramate generate for infrastructure and applications
  * Terraform plan
  * Terraform apply (only on main branch push)

### Terraform Destroy (terraform-destroy.yaml)

* Triggered manually via workflow_dispatch.
* Steps:
  * Environment setup
  * Terraform, Terramate, and Terrafile initialization
  * Terraform destroy
* Logs are captured to destroy.log in case of errors.

## References

- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [Terramate Documentation](https://terramate.io)
- [Terrafile Documentation](https://github.com/coretech/terrafile)
- [AWS Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
