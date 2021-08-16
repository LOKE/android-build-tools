#!/usr/bin/env bash
set -e

PROJECT_NAME="android-build-tools"
IMAGE_BASE="loke/$PROJECT_NAME"

PUBLISH_DATE="$(date +"%Y-%m-%d")"


IMAGE_LATEST="$IMAGE_BASE:latest"
IMAGE_VERSIONED="$IMAGE_BASE:$PUBLISH_DATE-001"

echo Building Docker Image: "$IMAGE_LATEST" "$IMAGE_VERSIONED"

docker build \
  -t "$IMAGE_LATEST" \
  .

docker push "$IMAGE_LATEST"

docker tag "$IMAGE_LATEST" "$IMAGE_VERSIONED"
docker push "$IMAGE_VERSIONED"
