# AWS Reliability & Fault-Tolerant Infrastructure

Terraform-based infrastructure as code (IaC) repository for deploying a reliable, fault-tolerant, and resilient AWS architecture.

## Architecture Principles

- **High Availability (HA):** Services deployed across multiple Availability Zones (AZs).
- **Fault Tolerance:** Auto-recovery through Auto Scaling, health checks, Multi-AZ databases, and load balancing.
- **Resilience:** Automated backups, disaster recovery (DR) patterns, circuit breakers, and self-healing mechanisms.
- **Security & Governance:** Encryption by default, least-privilege IAM, tagging enforcement, and Policy-as-Code.
- **Operational Excellence:** Centralized logging, monitoring, alerting, and CI/CD-driven deployments.

## Repository Structure

```
.
├── README.md
├── backend.tf                 # Remote state backend configuration (S3 + DynamoDB)
├── providers.tf               # AWS provider and required versions
├── locals.tf                  # Common local values
├── variables.tf               # Root input variables
├── outputs.tf                 # Root outputs
├── terraform.tfvars.example   # Example variable values
├── docs/                      # Architecture, governance, and runbook documentation
├── environments/              # Environment-specific configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/                   # Reusable Terraform modules
│   ├── vpc/
│   ├── compute/
│   ├── database/
│   ├── load_balancer/
│   ├── storage/
│   ├── backup/
│   ├── security/
│   ├── monitoring/
│   └── dns/
├── policies/                  # Policy-as-Code (Sentinel / OPA / IAM)
├── scripts/                   # Helper shell scripts
├── .github/                   # CI/CD workflows
├── .pre-commit-config.yaml    # Pre-commit hooks
├── .tflint.hcl                # Terraform lint configuration
└── tfsec.yml                  # Terraform security scanning
```

## Environments

| Environment | Purpose | File Path |
|-------------|---------|-----------|
| `dev`       | Development & experimentation | `environments/dev/` |
| `staging`   | Pre-production validation | `environments/staging/` |
| `prod`      | Production workload | `environments/prod/` |

## Getting Started

1. Install prerequisites:
   - Terraform >= 1.7
   - AWS CLI
   - tflint
   - tfsec

2. Initialize Terraform for an environment:
   ```bash
   terraform init "-backend-config=environments/dev/backend.tfvars"
   ```

3. Plan changes:
   ```bash
   terraform plan "-var-file=environments/dev/terraform.tfvars"
   ```

4. Apply changes:
   ```bash
   terraform apply "-var-file=environments/dev/terraform.tfvars"
   ```

## Governance

- All resources must follow the tagging strategy defined in `docs/TAGGING.md`.
- State files are stored remotely with locking enabled.
- Security scanning is enforced via `tfsec` and `tflint`.
- Policy-as-Code rules are located in `policies/`.

## Roadmap

1. Define reusable modules.
2. Build root `main.tf` composition.
3. Implement CI/CD pipelines.
4. Add automated tests and compliance checks.
