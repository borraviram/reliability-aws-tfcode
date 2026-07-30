variable "aws_region" {
  description = "AWS region for primary deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "mcp-ai-architecture"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "owner" {
  description = "Team or individual responsible for the resources"
  type        = string
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.23.0.0/16"
}

variable "enable_dr" {
  description = "Enable disaster recovery resources in a secondary region"
  type        = bool
  default     = false
}

variable "dr_region" {
  description = "Secondary AWS region for disaster recovery"
  type        = string
  default     = "us-west-2"
}
