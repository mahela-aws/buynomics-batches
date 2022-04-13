provider "aws" {
  region = "us-east-1"
}

resource "aws_batch_compute_environment" "bn_compute_environment" {
  compute_environment_name = var.compute_environment_name

  compute_resources {
    max_vcpus = var.compute_environment_max_vcpus

    security_group_ids = [
      aws_security_group.bn_conpute_environment_sg.id
    ]

    subnets = [
      aws_default_subnet.default_subnet.id
    ]

    type = var.compute_environment_compute_resource_type
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
  type         = var.compute_environment_type
  state        = "ENABLED"
}

resource "aws_batch_job_queue" "bn_job_queue" {
  name     = var.batch_job_queue_name
  state    = "ENABLED"
  priority = var.batch_job_queue_priority
  compute_environments = [
    aws_batch_compute_environment.bn_compute_environment.arn
  ]
}

resource "aws_batch_job_definition" "bn_job_definition" {
  name     = var.batch_job_definition_name
  type     = "container"
  platform_capabilities = ["FARGATE"]
  retry_strategy {
    attempts = var.batch_job_retry_strategy_attempts
  }

  container_properties = <<CONTAINER_PROPERTIES
{
    "command": ["ls", "-la"],
    "image": "${var.image_uri}",
    "resourceRequirements": [
    {"type": "VCPU", "value": "${var.container_properties_vcpus}"},
    {"type": "MEMORY", "value": "${var.container_properties_memory}"}
    ],
    "executionRoleArn": "${aws_iam_role.ecs_task_execution_role.arn}",
    "fargatePlatformConfiguration": { "platformVersion": "${var.container_properties_fargate_platform_version}" },
    "logConfiguration": {
         "logDriver": "${var.container_properties_log_driver}"
      }
}
CONTAINER_PROPERTIES
}
