output "public_ip" {
  description = "Public IPv4 address of the web server."
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "Public DNS name of the web server."
  value       = aws_instance.web.public_dns
}

