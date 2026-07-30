# Root composition for mcp-ai-architecture.

module "vpc" {
  source = "./modules/vpc"

  name_prefix        = local.naming_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = local.common_tags
}

# Future module calls:
# module "compute" {
#   source = "./modules/compute"
#   ...
# }
#
# module "database" {
#   source = "./modules/database"
#   ...
# }
#
# module "load_balancer" {
#   source = "./modules/load_balancer"
#   ...
# }
#
# module "monitoring" {
#   source = "./modules/monitoring"
#   ...
# }
