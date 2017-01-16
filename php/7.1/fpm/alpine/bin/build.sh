#!/bin/bash

set -ex

REPOSITORY_NAME="voskobovich/symfony3-php"
MAJOR_TAG="7.1.0-fpm-alpine"
MINOR_TAGS="7.1-fpm-alpine 7-fpm-alpine fpm-alpine"

docker build -t "${REPOSITORY_NAME}:${MAJOR_TAG}" .
docker push "${REPOSITORY_NAME}:${MAJOR_TAG}"

# Tag and push image for each additional tag
for TAG in ${MINOR_TAGS}; do
    docker tag "${REPOSITORY_NAME}:${MAJOR_TAG}" "${REPOSITORY_NAME}:${TAG}"
    docker push "${REPOSITORY_NAME}:${TAG}"
done
