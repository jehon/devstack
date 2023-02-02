#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

. "$SWD/build/lib.sh"

cd "$PRJ_ROOT"

# if [ $(sysctl --value vm.max_map_count) -lt 262144 ]; then
#     echo "Adapting max_map_count"
#     # 65530 => 262144
#     sudo sysctl -w vm.max_map_count=262144
# fi

#
# Sonar need (elasticSearch in fact):
# sysctl -w vm.max_map_count=524.288 <= 65.530
# sysctl -w fs.file-max=131072
# ulimit -n 131072
# ulimit -u 8192
#

mkdir -p jenkins/built/secrets
if [ ! -r jenkins/built/secrets/master.key ]; then
    cp -f /etc/jehon/restricted/jenkins-master.key jenkins/built/secrets/master.key
fi

OPTS=( )
case "$1" in
    "-f" )
        runDockerCompose down
        runDockerCompose rm -f
        OPTS+="--build"
        ;;
    "-d" )
        OPTS+="-d"
        ;;
esac

runDockerCompose up --remove-orphans "${OPTS[@]}"
