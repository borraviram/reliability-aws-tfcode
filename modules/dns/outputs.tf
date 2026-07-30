output "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.this.zone_id
}

output "primary_record_name" {
  description = "FQDN of the primary application record"
  value       = aws_route53_record.app.name
}
