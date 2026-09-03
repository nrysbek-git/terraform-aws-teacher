variable "name" {
  description = "Name prefix for web resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the instance."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for EC2 instances."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnets for the Application Load Balancer."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "allowed_http_cidrs" {
  description = "CIDRs allowed to reach the public load balancer."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
