output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = aws_kms_key.this.arn
}

output "instance_role_arn" {
  description = "ARN of the EC2 instance IAM role"
  value       = aws_iam_role.instance.arn
}
