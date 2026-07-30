variable "name_prefix" {
  description = "Naming prefix for compute resources"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where instances will be deployed"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ALB target group ARNs to attach instances"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
