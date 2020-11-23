#!/usr/bin/env bash

DOCKER_REGISTRY=registry.office.garaji.com

function getLocalTag() {
  echo ${TRAVIS_REPO_SLUG}:latest
}

function getRemoteTag() {
  echo ${DOCKER_REGISTRY}/${TRAVIS_REPO_SLUG}:${TRAVIS_TAG}
}

function imageBuild() {
  docker build --no-cache --rm -t $(getLocalTag) .
}

function imageTag() {
  if [[ ! -z "${TRAVIS_TAG}" ]]; then
    docker tag $(getLocalTag) $(getRemoteTag)
  else
    echo Skipping tag
  fi
}

function dockerLogin() {
    echo "${DOCKER_PASSWORD}" | docker login ${DOCKER_REGISTRY} -u "${DOCKER_USERNAME}" --password-stdin
}

function imagePush() {
  dockerLogin

  if [[ ! -z "${TRAVIS_TAG}" ]]; then
    docker push $(getRemoteTag)
  else
    echo Skipping publish
  fi
}

case $1 in
     build-image)
          imageBuild
          ;;
     tag-image)
          imageTag
          ;;
     push-image)
          imagePush
          ;;
esac
