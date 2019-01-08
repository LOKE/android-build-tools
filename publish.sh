#!/usr/bin/env bash
set -e

PROJECT_NAME="android-build-tools"
ANDROID_API_VERSION="27"
IMAGE_NAME="loke/$PROJECT_NAME:latest"
export ANDROID_BUILD_TOOLS_VERSION="27.0.3"

echo Building Docker Image: "$IMAGE_NAME"
./build.sh "$IMAGE_NAME"
docker push "$IMAGE_NAME"

docker tag "$IMAGE_NAME" "loke/$PROJECT_NAME:$ANDROID_API_VERSION-fastlane"
docker push "loke/$PROJECT_NAME:$ANDROID_API_VERSION"
