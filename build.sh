#! /bin/bash

docker build \
  --build-arg BUILD_TOOLS_VERSION=25.0.2 \
  --build-arg SDK_VERSION=25.2.3 \
  --build-arg NDK_VERSION=13 \
  -t $1 \
  .
