terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.75.1"
    }
  }
}

# Configure the AWS Provider
# Credentials can be provided by using the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and optionally AWS_SESSION_TOKEN environment variables. (https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
provider "aws" {
  region = var.AWSRegion
}
