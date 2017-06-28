#!/usr/bin/env bash
set -e

PROJECT_NAME="android-build-tools"
BUILDKITE_BUILD_ID="latest"
IMAGE_NAME="loke/$PROJECT_NAME:$BUILDKITE_BUILD_ID"
export ANDROID_BUILD_TOOLS_VERSION="25.0.2"

echo Building Docker Image: "$IMAGE_NAME"
./build.sh "$IMAGE_NAME"
# docker push "$IMAGE_NAME"

# docker tag "$IMAGE_NAME" "loke/$PROJECT_NAME:$ANDROID_BUILD_TOOLS_VERSION"
# docker push "loke/$PROJECT_NAME:$ANDROID_BUILD_TOOLS_VERSION"
