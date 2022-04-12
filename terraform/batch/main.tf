provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet" {}

# Create a security group for compute environment.
resource "aws_security_group" "bn_conpute_environment_sg" {
  name        = "bn-compute-environment-sg"
  description = "Security group for compute environment."
  vpc_id      = aws_default_vpc.default_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_batch_compute_environment" "bn_compute_environment" {
  compute_environment_name = "bn-compute-environment-small"

  compute_resources {
    max_vcpus = 1024

    security_group_ids = [
      aws_security_group.bn_conpute_environment_sg.id
    ]

    subnets = [
      aws_default_subnet.default_subnet.id
    ]

    type = "FARGATE"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
  type         = "MANAGED"
  state        = "ENABLED"
}

resource "aws_batch_job_queue" "bn_job_queue" {
  name     = "bn-job-queue-small"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.bn_compute_environment.arn
  ]
}

resource "aws_batch_job_definition" "bn_job_definition" {
  name     = "bn-job-definition-general"
  type     = "container"
  attempts = 2
  state    = "ENABLED"

  container_properties = <<CONTAINER_PROPERTIES
{
    "command": ["ls", "-la"],
    "image": "amazonlinux",
    "memory": 2048,
    "vcpus": 1,
    "executionRoleArn": "<<UPDATE_ROLE_ARN_HERE>>"
    "volumes": [
      {
        "host": {
          "sourcePath": "/tmp"
        },
        "name": "tmp"
      }
    ],
    "mountPoints": [
        {
          "sourceVolume": "tmp",
          "containerPath": "/tmp",
          "readOnly": false
        }
    ],
    "platformCapabilities": ["FARGATE"],
    "logConfiguration": {
         "logDriver": "awslogs",
         "options": {
            "string" : "string"
         }
      },
    "ulimits": [
      {
        "hardLimit": 1024,
        "name": "nofile",
        "softLimit": 1024
      }
    ]
}
CONTAINER_PROPERTIES
}
