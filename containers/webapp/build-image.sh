#!/usr/bin/env sh
#

if [[ ! "$OSTYPE" == "darwin"* ]]; then
    echo "Script tested only in MacOS. Exiting..."
    exit 1
fi

PWD=$(pwd)
TAG="0.2"

# DOCKER_TLS_VERIFY= docker buildx build \
    # --push \
    # -t 100.86.96.59/sgerbwd-webapp:$TAG \
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t stelolabs.inanga-polaris.ts.net/sgerbwd-webapp:$TAG \
    -f $PWD/containers/webapp/Dockerfile \
    --push \
    .
