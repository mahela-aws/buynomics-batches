variable "image_uri" {
  description = "Docker image uri."
  type        = string
}

variable "compute_environment_name" {
  description = "Batch compute environment name."
  type        = string
  default     = "bn-compute-environment-small"
}

variable "compute_environment_compute_resource_type" {
  description = "Batch compute environment compute resource type."
  type        = string
  default     = "FARGATE"
}

variable "compute_environment_type" {
  description = "Batch compute environment type."
  type        = string
  default     = "MANAGED"
}

variable "compute_environment_max_vcpus" {
  description = "Batch compute environment max vcpus."
  type        = number
  default     = 1024
}

variable "batch_job_queue_name" {
  description = "Batch job queue name."
  type        = string
  default     = "bn-job-queue-small"
}

variable "batch_job_queue_priority" {
  description = "Batch job queue priority."
  type        = number
  default     = 1
}

variable "batch_job_definition_name" {
  description = "Batch job definition name."
  type        = string
  default     = "bn-job-definition-general"
}

variable "batch_job_retry_strategy_attempts" {
  description = "Batch job retry strategy attempts."
  type        = number
  default     = 2
}

variable "container_properties_vcpus" {
  description = "Container properties vcpus."
  type        = string
  default     = "1"
}

variable "container_properties_memory" {
  description = "Container properties memory."
  type        = string
  default     = "2048"
}

variable "container_properties_fargate_platform_version" {
  description = "Container properties fargate platform version."
  type        = string
  default     = "1.3.0"
}

variable "container_properties_log_driver" {
  description = "Container properties log driver."
  type        = string
  default     = "awslogs"
}
