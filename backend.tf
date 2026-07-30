# Remote state configuration using S3 and DynamoDB for state locking.
# Per-environment backend parameters are supplied via -backend-config flags.

terraform {
  backend "s3" {
    # These values are intentionally left empty; they are provided by environment-specific backend.tfvars
    bucket         = ""
    key            = ""
    region         = ""
    encrypt        = true
    dynamodb_table = ""
  }
}
