#!/usr/bin/env bash

# HOST
export JENKINS_HOST_EXPORT="/mnt/docker/jenkins"
export JENKINS_HOST_SECRETS="/etc/jehon/restricted/jenkins"
export JENKINS_HOST_CONFIGS="$JH_SWD/config"

# Docker
export JENKINS_DOCKER_TAG="jehon-jenkins:local"
export JENKINS_DOCKER_NAME="jenkins-master"

# Inside docker
export JENKINS_GUEST_HOME="/var/jenkins_home"
export JENKINS_GUEST_EXPORT="$JENKINS_HOST_EXPORT"
export JENKINS_GUEST_SECRETS="/secrets"
