#! /bin/bash

docker build \
  --build-arg BUILD_TOOLS_VERSION=27.0.3 \
  --build-arg SDK_VERSION=27.0.3 \
  --build-arg NDK_VERSION=13 \
  -t $1 \
  .
