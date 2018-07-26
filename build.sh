#! /bin/bash

docker build \
  --build-arg BUILD_TOOLS_VERSION=26.0.2 \
  --build-arg SDK_VERSION=26.0.2 \
  --build-arg NDK_VERSION=13 \
  -t $1 \
  .
