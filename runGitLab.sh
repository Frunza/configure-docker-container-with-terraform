#!/bin/sh

# Exit immediately if a simple command exits with a nonzero exit value
set -e

docker build -f docker/gitlab.dockerfile -t gitlabterraformcontainer .
docker-compose -f docker/gitlab.docker-compose.yml run --rm update
