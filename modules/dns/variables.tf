variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB to point records to"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
