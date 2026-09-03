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

