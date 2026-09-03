output "public_ip" {
  description = "Public IPv4 address of the web server."
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "Public DNS name of the web server."
  value       = aws_instance.web.public_dns
}

output "instance_id" {
  description = "EC2 instance ID, also used to start an SSM Session Manager session."
  value       = aws_instance.web.id
}

output "cloudwatch_alarm_arn" {
  description = "ARN of the high CPU CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.high_cpu.arn
}
