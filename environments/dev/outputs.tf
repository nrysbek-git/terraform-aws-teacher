output "website_url" {
  description = "Open this URL after apply."
  value       = "http://${module.web_server.public_dns}"
}

output "vpc_id" {
  description = "Created VPC ID."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Created public subnet IDs."
  value       = module.network.public_subnet_ids
}

output "public_subnets" {
  description = "Subnet IDs and CIDRs keyed by availability zone."
  value       = module.network.public_subnets
}

output "deployment_context" {
  description = "Non-sensitive AWS context useful for verification and CI logs."
  value = {
    account_id         = data.aws_caller_identity.current.account_id
    region             = data.aws_region.current.name
    environment        = var.environment
    availability_zones = local.selected_availability_zones
  }
}

output "instance_id" {
  description = "EC2 ID for inventory and SSM Session Manager."
  value       = module.web_server.instance_id
}

output "cloudwatch_alarm_arn" {
  description = "High CPU alarm created for the EC2 instance."
  value       = module.web_server.cloudwatch_alarm_arn
}
