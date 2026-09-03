output "endpoint" {
  description = "Private PostgreSQL endpoint."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "PostgreSQL port."
  value       = aws_db_instance.this.port
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN generated and managed by RDS."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
