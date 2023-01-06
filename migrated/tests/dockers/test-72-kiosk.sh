#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-packages-test.sh
. "$SWD/lib-packages-test.sh"

(
	cat <<-'EOS'
		( cd /setup/ansible && ansible-playbook setup.yml --connection=local --limit kiosk )

		ok_ko "user jh-kiosk" "id jh-kiosk >/dev/null"
		ok_ko "git checkout was ok" "[ -r /opt/jehon/kiosk/package.json ]"
		ok_ko "node is installed" "type node"
		ok_ko "npm is installed" "type npm"

		echo "Trying to launch jh-kiosk-file-selector"
		/usr/bin/jh-kiosk-file-selector -h || jh_fatal "file-selector not ok"

		jh-checks | jh-tag-stdin "checks" || true
	EOS
) | test_in_docker
