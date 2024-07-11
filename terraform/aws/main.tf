terraform {
  required_version = "1.5.0"
  backend "s3" {
    bucket = "aws-my-company-s3-remote-terraform-state-files"
    key    = "core.tf"
    region = "eu-central-1"
  }
}
