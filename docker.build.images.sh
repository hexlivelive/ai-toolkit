#!/bin/bash
set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

VERSION="latest" # Default values if undefined

REPOSITORY_URL="hexlive"

# Cleanup the docker env. Remove all images and builders
# docker image prune -a --filter "until=4h" -f
docker builder prune --filter "until=1h" -f


echo "Building images with version: $VERSION"


buildImage() {
  DOCKERFILE="$1"
  CONTAINER_NAME="$2"

  if [ "$#" -ne 2 ]; then
    echo "Invalid amount of parameters!"
    exit
  fi
  echo "----------------------------------------"
  echo "Building, tagging, and pushing docker file $DOCKERFILE for container $CONTAINER_NAME with version $VERSION"
  echo "----------------------------------------"

  DOCKER_BUILDKIT=1 docker build --progress=plain --no-cache --platform linux/amd64 -f $DOCKERFILE -t $REPOSITORY_URL/$CONTAINER_NAME:$VERSION .
  
  docker image push $REPOSITORY_URL/$CONTAINER_NAME:$VERSION

  echo "Done building, tagging, and pushing $REPOSITORY_URL/$CONTAINER_NAME:$VERSION"
}

DOCKER_ACCESS_TOKEN=""

if [ "$CI" = "true" ]; then
  echo "Running in CI. Getting secrets from env variables"
else
  echo "Not running in CI. Copy Secrets from disk"
fi

echo "Logging into dockerhub registry"
docker login -u hexlive -p $DOCKER_HUB_TOKEN
echo "Logged in"

buildImage Dockerfile.ai.gpucrunch.base ai_gpucrunch_base
buildImage Dockerfile.ai.gpucrunch.toolkit ai_gpucrunch_toolkit