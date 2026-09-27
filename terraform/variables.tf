variable "aws_region" {
  description = "AWS region used by the project"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "agriculture-data-pipeline"
}

variable "alert_email" {
  description = "Email address for pipeline alerts"
  type        = string
}