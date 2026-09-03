variable "name" {
  description = "Name prefix for database resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the database."
  type        = string
}

variable "subnet_ids" {
  description = "Isolated database subnet IDs."
  type        = list(string)
}

variable "application_security_group_id" {
  description = "Security group allowed to connect to PostgreSQL."
  type        = string
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

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
