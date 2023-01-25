#!/usr/bin/env bash

set -o errexit

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"
. "$SWD"/jenkins-lib.sh

. "$PRJ_ROOT/ansible/lib.sh"

#
# About ? 
#    secrets/master.key
#
#  Thanks to https://stackoverflow.com/a/38474024/1954789
#
TARGET="$PRJ_TMP/jenkins"
mkdir -p "$TARGET"

echo "## Backup secrets..."
docker compose cp "$JENKINS_DOCKER_NAME:$JENKINS_GUEST_HOME/secrets/master.key" "$TARGET/"
echo "## Backup secrets done"

echo "# Encrypting master.key..."
cd "$PRJ_ROOT/ansible"
cat $TARGET/master.key | ansible-vault encrypt_string > $TARGET/master.key.encrypted
echo "# Encrypting master.key done"

echo "***"
echo "* Secrets are at $TARGET"
echo "***"
