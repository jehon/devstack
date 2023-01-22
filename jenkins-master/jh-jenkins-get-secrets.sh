#!/usr/bin/env bash

set -o errexit

. /usr/bin/jh-lib
. "$JH_SWD"/jenkins-bin/jenkins-lib.sh

#
# About ? 
#    secrets/hudson.util.Secret and
#    secrets/master.key
#
#  Thanks to https://stackoverflow.com/a/38474024/1954789
#
TARGET="$JH_SWD/tmp"
mkdir -p "$TARGET"


echo "## Backup secrets..."
docker compose cp "$JENKINS_DOCKER_NAME:$JENKINS_GUEST_HOME/secrets/hudson.util.Secret" "$TARGET/"
docker compose cp "$JENKINS_DOCKER_NAME:$JENKINS_GUEST_HOME/secrets/master.key" "$TARGET/"
echo "## Backup secrets done"

echo "***"
echo "* Secrets are at $TARGET"
echo "***"
