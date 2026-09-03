output "state_bucket_name" {
  description = "Use this value in environments/dev/backend.hcl."
  value       = aws_s3_bucket.terraform_state.id
}

