terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "hitesh-tenant-eks"
    key            = "dedicated-resources"
    region         = "us-east-1"
    dynamodb_table = "hitesh-tenant-locking-dev"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}