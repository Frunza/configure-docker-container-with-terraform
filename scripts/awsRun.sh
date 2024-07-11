#!/bin/sh

# Exit immediately if a simple command exits with a nonzero exit value
set -e

echo "AWS terraform configuration started..."
terraform init && terraform validate && terraform apply -auto-approve
