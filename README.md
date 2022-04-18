# buynomics-batches
This document gives you instructions on how to deploy AWS Batch infrastructure using terrform

## Prerequisites

- AWS account with local credentials configure `~/.aws/credentials`
- aws cli installed and configured on your local environment.
- Terraform 0.14.7+ installed on your local workstation.


## Deploy AWS Batch infrastructure using terraform

Follow below steps to deploy aws batch infrastructure

- Move to terraform directory and initialize terraform
  - `cd terraform`
  - `terraform init`
- Run terraform plan to have glance at what resources will be created
  - `terraform plan`
- Run terraform apply to deploy flask demo application
  - `terraform apply`


#### Note
All aws resources will be created in us-east-1 region
