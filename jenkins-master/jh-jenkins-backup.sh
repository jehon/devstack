#!/usr/bin/env bash

set -o errexit
set -o pipefail

. /usr/bin/jh-lib
. "$JH_SWD"/jenkins-bin/jenkins-lib.sh

header_begin "Building up the backup"
docker exec --user root "$JENKINS_DOCKER_NAME" /jenkins-bin/jenkins-inside-backup.sh
header_end

header_begin "Synchronizing the bakcup"
rsync -ir \
    --ignore-times --checksum \
    --delete \
    "$JENKINS_GUEST_EXPORT/" "$JENKINS_HOST_CONFIGS"
header_end
