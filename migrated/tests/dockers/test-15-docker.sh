#!/usr/bin/env bash

#
# We expose two variable to reuse it from start-debian
#   TEST_OS
#   TEST_NAME
#

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-packages-test.sh
. "$SWD/lib-packages-test.sh"

TAG="jehon/devcontainer-docker:local"

cd "$SWD" && docker build -f Dockerfile.docker --tag "$TAG" . | jh-tag-stdin "building $TAG"

(
	cat <<-'EOS'
		docker ps
	EOS
) | test_in_docker "$TAG"
