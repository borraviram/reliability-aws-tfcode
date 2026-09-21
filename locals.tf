locals {
  project_name = var.project_name
  environment  = var.environment

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
    owner       = var.owner
    CostCenter  = var.cost_center
  }

  naming_prefix = "${local.project_name}-${local.environment}"
}
