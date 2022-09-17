#!/bin/bash
#
# Downloads the default container and pushes to ECR
#
# Pre-requisites:
#  - docker cli
#  - aws cli

set -e

region="$1"
default_container="$2"
ecr_repo="$3"


aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$ecr_repo"
docker pull "$default_container"
docker tag "$default_container" "$ecr_repo"
docker push "$ecr_repo"
