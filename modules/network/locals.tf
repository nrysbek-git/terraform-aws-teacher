locals {
  public_subnets = {
    for index, availability_zone in var.availability_zones :
    availability_zone => cidrsubnet(var.vpc_cidr, 8, index)
  }

  private_subnets = {
    for index, availability_zone in var.availability_zones :
    availability_zone => cidrsubnet(var.vpc_cidr, 8, index + 10)
  }

  database_subnets = {
    for index, availability_zone in var.availability_zones :
    availability_zone => cidrsubnet(var.vpc_cidr, 8, index + 20)
  }
}
