bucket         = "tf-state-reliability-architecture-dev"
key            = "reliability-architecture/dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "tf-locks-reliability-architecture-dev"
