variable "name_prefix" {
  description = "Naming prefix for database resources"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., aurora-mysql, postgres)"
  type        = string
}

variable "subnet_ids" {
  description = "Database subnet IDs"
  type        = list(string)
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
