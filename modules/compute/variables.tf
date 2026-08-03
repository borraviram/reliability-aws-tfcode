variable "name_prefix" {
  description = "Naming prefix for compute resources"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where instances will be deployed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the instances"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "user_data" {
  description = "User data script for bootstrapping instances"
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "target_group_arns" {
  description = "ALB target group ARNs to attach instances"
  type        = list(string)
  default     = []
}
