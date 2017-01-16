#!/bin/bash

set -ex

REPOSITORY_NAME="voskobovich/symfony3-php"
BUILD_TAG="7.1.0-fpm-alpine"

docker build -t ${REPOSITORY_NAME}:${BUILD_TAG} .

# Tag and push image for each additional tag
for TAG in 7.1-fpm-alpine 7-fpm-alpine fpm-alpine; do
    docker tag "${REPOSITORY_NAME}:${BUILD_TAG}" "${REPOSITORY_NAME}:${TAG}"
    docker push "${REPOSITORY_NAME}:${TAG}"
done
