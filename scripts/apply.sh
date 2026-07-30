#!/usr/bin/env bash
# Run Terraform apply for a given environment.
# Usage: ./scripts/apply.sh <environment>

set -euo pipefail

ENVIRONMENT="${1:-dev}"

echo "Running Terraform apply for environment: ${ENVIRONMENT}"

terraform init -backend-config="environments/${ENVIRONMENT}/backend.tfvars" -reconfigure
terraform apply -var-file="environments/${ENVIRONMENT}/terraform.tfvars"
