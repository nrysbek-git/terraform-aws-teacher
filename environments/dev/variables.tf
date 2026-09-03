variable "aws_region" {
  description = "AWS region for lab resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project identifier."
  type        = string
  default     = "terraform-foundations"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR allocated to the VPC."
  type        = string
  default     = "10.30.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "instance_type" {
  description = "EC2 instance type used by the web server."
  type        = string
  default     = "t3.micro"
}

variable "enable_billable_resources" {
  description = "Explicit confirmation that NAT Gateway, ALB, EC2 and RDS incur charges."
  type        = bool

  validation {
    condition     = var.enable_billable_resources
    error_message = "Set enable_billable_resources=true only after reviewing AWS cost and cleanup instructions."
  }
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "foundations"
}

variable "database_username" {
  description = "PostgreSQL administrator username."
  type        = string
  default     = "foundation_admin"
}
