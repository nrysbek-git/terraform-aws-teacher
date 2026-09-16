module "network" {
  source = "../../modules/network"

  name               = local.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = local.selected_availability_zones
  tags               = local.common_tags
}

module "web_server" {
  source = "../../modules/web-server"

  name               = local.name
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids
  instance_type      = var.instance_type
  tags               = local.common_tags
}

module "database" {
  source = "../../modules/database"

  name                          = local.name
  vpc_id                        = module.network.vpc_id
  subnet_ids                    = module.network.database_subnet_ids
  application_security_group_id = module.web_server.web_security_group_id
  database_name                 = var.database_name
  database_username             = var.database_username
  tags                          = local.common_tags
}
