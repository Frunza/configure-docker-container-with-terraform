#!/bin/sh

# Exit immediately if a simple command exits with a nonzero exit value
set -e

docker build -f docker/aws.dockerfile -t awsterraformcontainer .
docker-compose -f docker/aws.docker-compose.yml run --rm update
