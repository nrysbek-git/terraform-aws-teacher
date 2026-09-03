output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of both public subnets."
  value       = [for availability_zone in var.availability_zones : aws_subnet.public[availability_zone].id]
}

output "public_subnets" {
  description = "Public subnet details keyed by availability zone."
  value = {
    for availability_zone, subnet in aws_subnet.public : availability_zone => {
      id         = subnet.id
      cidr_block = subnet.cidr_block
    }
  }
}
