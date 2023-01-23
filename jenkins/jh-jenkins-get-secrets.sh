#!/usr/bin/env bash

set -o errexit

. /usr/bin/jh-lib
DS_ROOT="$( dirname "$JH_SWD" )"

. "$JH_SWD"/jenkins-bin/jenkins-lib.sh
. "$DS_ROOT/ansible/lib.sh"


#
# About ? 
#    secrets/hudson.util.Secret and
#    secrets/master.key
#
#  Thanks to https://stackoverflow.com/a/38474024/1954789
#
TARGET="$DS_ROOT/tmp/jenkins"
mkdir -p "$TARGET"

echo "## Backup secrets..."
docker compose cp "$JENKINS_DOCKER_NAME:$JENKINS_GUEST_HOME/secrets/hudson.util.Secret" "$TARGET/"
docker compose cp "$JENKINS_DOCKER_NAME:$JENKINS_GUEST_HOME/secrets/master.key" "$TARGET/"
echo "## Backup secrets done"

echo "# Encrypting secrets..."
cd "$DS_ROOT/ansible"
echo "## Encrypting master.key"
cat $TARGET/master.key | ansible-vault encrypt_string > $TARGET/master.key.encrypted
echo "## Encrypting hudson.util.Secret"
cat $TARGET/hudson.util.Secret | base64 | ansible-vault encrypt_string > $TARGET/hudson.util.Secret.encrypted
echo "# Encrypting secrets done"

echo "***"
echo "* Secrets are at $TARGET"
echo "***"
