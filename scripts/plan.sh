#!/usr/bin/env bash
# Run Terraform plan for a given environment.
# Usage: ./scripts/plan.sh <environment>

set -euo pipefail

ENVIRONMENT="${1:-dev}"

echo "Running Terraform plan for environment: ${ENVIRONMENT}"

terraform init -backend-config="environments/${ENVIRONMENT}/backend.tfvars" -reconfigure
terraform plan -var-file="environments/${ENVIRONMENT}/terraform.tfvars"
