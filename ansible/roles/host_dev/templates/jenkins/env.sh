#!/usr/bin/env bash

set -o errexit

export JENKINS_SYSTEM_USER="{{ jehon.credentials.jenkins.system_user }}"
export JENKINS_SYSTEM_KEY="{{ jehon.credentials.jenkins.system_key }}"
