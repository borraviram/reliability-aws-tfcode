bucket         = "tf-state-reliability-architecture-prod"
key            = "reliability-architecture/prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "tf-locks-reliability-architecture-prod"
