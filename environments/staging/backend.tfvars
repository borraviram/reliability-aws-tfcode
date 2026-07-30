bucket         = "tf-state-reliability-architecture-staging"
key            = "reliability-architecture/staging/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "tf-locks-reliability-architecture-staging"
