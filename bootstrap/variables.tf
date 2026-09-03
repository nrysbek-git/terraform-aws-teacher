variable "aws_region" {
  description = "AWS region for the state resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for bootstrap resources."
  type        = string
  default     = "terraform-foundations"
}

