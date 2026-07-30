variable "name_prefix" {
  description = "Naming prefix for backup resources"
  type        = string
}

variable "backup_resources" {
  description = "List of ARNs to include in backup plans"
  type        = list(string)
  default     = []
}

variable "enable_cross_region_copy" {
  description = "Enable cross-region copy for disaster recovery"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
