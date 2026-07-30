#!/usr/bin/env bash
# Bootstrap remote state backend resources for a given environment.
# Usage: ./scripts/bootstrap-backend.sh <environment>

set -euo pipefail

ENVIRONMENT="${1:-dev}"
PROJECT="mcp-ai-architecture"
REGION="us-east-1"

BUCKET_NAME="tf-state-${PROJECT}-${ENVIRONMENT}"
LOCK_TABLE="tf-locks-${PROJECT}-${ENVIRONMENT}"

echo "Bootstrapping backend for environment: ${ENVIRONMENT}"

# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket "${BUCKET_NAME}" \
  --region "${REGION}" \
  --create-bucket-configuration LocationConstraint="${REGION}" 2>/dev/null || true

aws s3api put-bucket-versioning \
  --bucket "${BUCKET_NAME}" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket "${BUCKET_NAME}" \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name "${LOCK_TABLE}" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${REGION}" 2>/dev/null || true

echo "Backend bootstrapped successfully."
echo "Bucket: ${BUCKET_NAME}"
echo "DynamoDB table: ${LOCK_TABLE}"
