#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-ansible-test.sh
. "$SWD/lib-ansible-test.sh"

(
	cat <<-'EOS'
		ansible-playbook setup.yml --connection=local --limit kiosk

		type jh-lib

		id jh-kiosk
		test -r /opt/jehon/kiosk/package.json
		type node
		type npm

		/usr/bin/jh-kiosk-file-selector -h

		jh-checks | jh-tag-stdin "checks" || true
	EOS
) | test_in_docker
