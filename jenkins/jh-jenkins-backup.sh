#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

. "$SWD"/jenkins-lib.sh

jenkins_check

. /usr/bin/jh-lib
. "$JH_SWD"/jenkins-bin/jenkins-lib.sh

header_begin "Building up the backup"
docker compose exec --user root "$JENKINS_DOCKER_NAME" /jenkins-bin/jenkins-inside-backup.sh
header_end

header_begin "Synchronizing the bakcup"
rsync -ir \
    --ignore-times --checksum \
    --delete \
    "/mnt/docker/jenkins/" "$JH_SWD/config"
header_end
