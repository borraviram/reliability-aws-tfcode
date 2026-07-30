output "environment" {
  description = "Current deployment environment"
  value       = local.environment
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}

# Additional outputs will be populated once modules are wired in main.tf.
