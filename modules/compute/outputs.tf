output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.this[*].id
}

output "instance_private_ips" {
  description = "List of private IP addresses of the EC2 instances"
  value       = aws_instance.this[*].private_ip
}

output "instance_availability_zones" {
  description = "List of availability zones where instances are deployed"
  value       = aws_instance.this[*].availability_zone
}
