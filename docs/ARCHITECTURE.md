# Architecture Overview

## Goals

Build an AWS infrastructure that is:

- **Reliable:** Minimize downtime through redundancy and health-aware automation.
- **Fault Tolerant:** Survive component, Availability Zone, and (optionally) region-level failures.
- **Resilient:** Detect failures automatically and recover without human intervention.
- **Governed:** Enforce security, compliance, and cost controls through Policy-as-Code.

## High-Level Design

```
                    ┌─────────────────────┐
                    │   Route 53 (DNS)    │
                    │  Health Checks +    │
                    │  Failover Policy    │
                    └─────────┬───────────┘
                              │
                    ┌─────────▼───────────┐
                    │  CloudFront / WAF   │
                    │   (Edge Security)   │
                    └─────────┬───────────┘
                              │
                    ┌─────────▼───────────┐
                    │ Application Load    │
                    │ Balancer (Multi-AZ) │
                    └─────────┬───────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   ┌────▼────┐           ┌────▼────┐           ┌────▼────┐
   │   AZ A  │           │   AZ B  │           │   AZ C  │
   │  EC2/   │           │  EC2/   │           │  EC2/   │
   │  ECS/   │           │  ECS/   │           │  ECS/   │
   │  EKS    │           │  EKS    │           │  EKS    │
   └────┬────┘           └────┬────┘           └────┬────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                    ┌─────────▼───────────┐
                    │ Multi-AZ Database   │
                    │  (RDS / Aurora)     │
                    └─────────────────────┘
                              │
                    ┌─────────▼───────────┐
                    │ Encrypted Storage   │
                    │   (S3 / EFS)        │
                    └─────────────────────┘
```

## Reliability Patterns

### 1. Multi-AZ Deployment

- Public subnets for load balancers.
- Private subnets for compute workloads.
- Dedicated database subnets for RDS/Aurora.
- NAT Gateway per AZ for outbound resiliency.

### 2. Auto Scaling & Self-Healing

- Auto Scaling Groups (ASG) with target tracking policies.
- ELB health checks replace unhealthy instances.
- Instance refresh for zero-downtime deployments.

### 3. Data Protection

- Automated RDS backups and point-in-time recovery.
- AWS Backup plans for EBS, EFS, RDS, and DynamoDB.
- Cross-region backup copies for disaster recovery.

### 4. Security in Depth

- KMS customer-managed keys for encryption at rest.
- TLS 1.2+ for data in transit.
- Security groups with least-privilege rules.
- WAF + Shield Advanced for public endpoints.
- IAM roles instead of long-lived access keys.

### 5. Observability

- CloudWatch Logs and Metrics.
- Alarms via SNS (email / Slack / PagerDuty).
- CloudWatch Dashboards for operational visibility.
- X-Ray distributed tracing.

## Disaster Recovery

| DR Tier | RTO | RPO | Pattern |
|---------|-----|-----|---------|
| Pilot Light | Hours | Minutes | Standby DB, replicated storage, automated recovery scripts. |
| Warm Standby | Minutes | Seconds | Scaled-down secondary environment ready to scale. |
| Multi-Region Active-Active | Near-zero | Near-zero | Full traffic distribution across regions. |

For this project, **Pilot Light / Warm Standby** is the default target in `prod` (`enable_dr = true`).

## Compliance & Governance

- Sentinel / OPA policies enforce encryption and Multi-AZ.
- TFLint + TFSec in CI for code quality and security.
- Centralized state management with S3 + DynamoDB.
- Mandatory tagging for cost allocation and ownership.
