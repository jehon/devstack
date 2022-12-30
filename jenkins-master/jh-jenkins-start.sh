#!/usr/bin/env bash

set -o errexit
set -o pipefail

. /usr/bin/jh-lib
. "$JH_SWD"/jenkins-bin/jenkins-lib.sh

cd "$JH_SWD"
mkdir -p "$JENKINS_HOST_EXPORT"

if [ -n "$1" ] && docker container ps | grep "$JENKINS_DOCKER_TAG" ; then
    docker start "$JENKINS_DOCKER_TAG"
else
    docker build --tag "$JENKINS_DOCKER_TAG" .
    #     "source=/etc/jehon/restricted/ansible-key,target=/etc/jehon/restricted/ansible-key,type=bind",

    docker kill "$JENKINS_DOCKER_NAME" &>/dev/null || true
    docker container rm "$JENKINS_DOCKER_NAME" &>/dev/null || true

    docker run \
        --publish 8080:8080 \
        --publish 127.0.0.1:50000:50000 \
        --mount "type=bind,source=$JENKINS_HOST_SECRETS,target=$JENKINS_GUEST_SECRETS" \
        --mount "type=bind,source=$JENKINS_HOST_EXPORT,target=$JENKINS_GUEST_EXPORT" \
        --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
        --name "$JENKINS_DOCKER_NAME" \
        --restart=unless-stopped \
        "$JENKINS_DOCKER_TAG" \
        --prefix=/jenkins
fi
