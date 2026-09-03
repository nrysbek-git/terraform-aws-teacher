output "load_balancer_dns" {
  description = "Public DNS name of the Application Load Balancer."
  value       = aws_lb.web.dns_name
}

output "instance_ids" {
  description = "EC2 instance IDs, also used for SSM Session Manager."
  value       = [for instance in values(aws_instance.web) : instance.id]
}

output "cloudwatch_alarm_arn" {
  description = "ARN of the high CPU CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.high_cpu.arn
}

output "web_security_group_id" {
  description = "Security group attached to the private web instances."
  value       = aws_security_group.web.id
}
