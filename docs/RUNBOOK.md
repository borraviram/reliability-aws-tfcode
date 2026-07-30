# Operational Runbook

## Terraform Deployment

### Initialize

```bash
terraform init -backend-config=environments/prod/backend.tfvars
```

### Plan

```bash
terraform plan -var-file=environments/prod/terraform.tfvars
```

### Apply

```bash
terraform apply -var-file=environments/prod/terraform.tfvars
```

## Failure Scenarios

### AZ Failure

- **Detection:** CloudWatch ALB/Target Group health check alarms.
- **Response:** ASG automatically launches replacement instances in healthy AZs.
- **Manual check:** Verify ALB target group targets are healthy across AZs.

### Database Failure

- **Detection:** RDS CloudWatch alarm (`DatabaseConnections`, `CPUUtilization`).
- **Response:** Multi-AZ RDS automatically fails over to standby.
- **Runbook:** Confirm failover via RDS events; update application connection strings if needed.

### Region Failure (DR)

- **Detection:** Route 53 health check failure.
- **Response:** DNS failover to DR region; scale up Warm Standby environment.
- **Runbook:** See `docs/DISASTER_RECOVERY.md`.

## Security Incidents

- Rotate compromised IAM credentials immediately.
- Review CloudTrail logs in `logs-YYYY-MM-DD` S3 bucket.
- Invoke incident response plan and notify security team.
