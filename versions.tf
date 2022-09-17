terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.67"
    }
    null   = ">= 3.1.0"
    random = ">= 3.1.0"
  }
}
