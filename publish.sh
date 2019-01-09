#!/usr/bin/env bash
set -e

PROJECT_NAME="android-build-tools"
IMAGE_BASE="loke/$PROJECT_NAME"

API_VERSION="27"
BUILD_TOOLS_VERSION="27.0.3"
NDK_VERSION="18b"

IMAGE_LATEST="$IMAGE_BASE:latest"
IMAGE_VERSIONED="$IMAGE_BASE:$API_VERSION"

echo Building Docker Image: "$IMAGE_LATEST"

docker build \
  --build-arg API_VERSION=$API_VERSION \
  --build-arg BUILD_TOOLS_VERSION=$BUILD_TOOLS_VERSION \
  --build-arg NDK_VERSION=$NDK_VERSION \
  -t "$IMAGE_LATEST" \
  .

docker push "$IMAGE_LATEST"

docker tag "$IMAGE_LATEST" "$IMAGE_VERSIONED"
docker push "$IMAGE_VERSIONED"
