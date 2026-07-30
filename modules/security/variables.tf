variable "name_prefix" {
  description = "Naming prefix for security resources"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
