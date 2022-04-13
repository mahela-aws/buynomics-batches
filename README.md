# buynomics-batches
This document gives you instructions on how to deploy AWS Batch infrastructure using terrform

## Prerequisites

- AWS account with local credentials configure `~/.aws/credentials`
- aws cli installed and configured on your local environment.
- Terraform 0.14.7+ installed on your local workstation.
- Docker desktop 3.1.0+ installed on local workstation.

## Publish custom docker image to ECR repository

Follow below steps to create ecr repository and publish docker image to ecr repository so that we could use it with our batch jobs.

- Parameters required
  - `aws profile`
  - `ecr repository name` - default [python3.8-repo]
  - `aws account id`

- Run below command to create ecr repository and publish docker image to ecr
  - `sh build-custom-image.sh`


#### Output

ECR image uri will be printed. This image uri will be required to run terraform code when deploying flask application.

  - Eg : `77244329318506.dkr.ecr.us-east-1.amazonaws.com/python3.8-repo:latest`


## Deploy AWS Batch infrastructure using terraform

Follow below steps to deploy aws batch infrastructure

- Parameters required
  - `ECR image uri`(you get this as an output when publishing docker image to ECR in previous step)

- Move to terraform directory and initialize terraform
  - `cd terraform`
  - `terraform init`
- Run terraform plan to have glance at what resources will be created
  - `terraform plan`
- Run terraform apply to deploy flask demo application
  - `terraform apply`


#### Note
All aws resources will be created in us-east-1 region

