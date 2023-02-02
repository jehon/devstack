#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

. "$(realpath "$( dirname "${BASH_SOURCE[0]}")")"/../build/jenkins-lib.sh

#
# About ? 
#    secrets/master.key
#
#  Thanks to https://stackoverflow.com/a/38474024/1954789
#
mkdir -p "$JENKINS_TMP"

echo "## Backup secrets..."
runDockerCompose cp "$JENKINS_DOCKER_NAME:$JENKINS_GUEST_HOME/secrets/master.key" "$JENKINS_TMP/"
echo "## Backup secrets done"

echo "# Encrypting master.key..."
cd "$JENKINS_ROOT"
cat $JENKINS_TMP/master.key | ansible-vault encrypt_string > $JENKINS_TMP/master.key.encrypted
echo "# Encrypting master.key done"

echo "***"
echo "* Secrets are at $JENKINS_TMP"
echo "***"
