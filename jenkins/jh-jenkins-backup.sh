#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

. "$SWD"/jenkins-lib.sh

EXPORT="$TMP/export"
CONFIG="$SWD/config"

echo "## Extract configs (into $EXPORT)..."
rm -fr "$EXPORT"
mkdir -p "$EXPORT"
docker compose cp jenkins:/var/jenkins_home/ "$EXPORT/"
echo "## Extract configs (into $EXPORT) done"

echo "## Backup raw data..."
echo "### jobs"
rsync --prune-empty-dirs --archive \
    --exclude "changelog.xml" --exclude "builds" \
    --include="*.xml" --include="*/" \
    --exclude="*" \
    --delete --delete-excluded \
    "$EXPORT/jenkins_home/jobs/" "$CONFIG/raw/jobs/"

echo "### nodes"
rsync --prune-empty-dirs --archive \
    --delete --delete-excluded \
    "$EXPORT/jenkins_home/nodes/" "$CONFIG/raw/nodes/"

echo "### users"
rsync --prune-empty-dirs --archive \
    --delete --delete-excluded \
    "$EXPORT/jenkins_home/users/" "$CONFIG/raw/users/"

echo "### others xml"
cp "$EXPORT/jenkins_home/"*.xml "$CONFIG/raw/"
echo "## Backup raw data done"

jenkins_check

echo "## Building plugins list..."
(
    # https://github.com/jenkinsci/docker/blob/master/README.md

    # curl -sSL "http://127.0.0.1:8080/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" \
    #     | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'

    cat <<"EOS" | jenkins_cli groovy "="
import jenkins.model.Jenkins;

Jenkins.instance.pluginManager.plugins
    .collect()
    .sort { it.getShortName() }
    .each {
        plugin -> println("${plugin.getShortName()}:${plugin.getVersion()}")
    }
EOS

) | tee "$EXPORT"/plugins.tmp | sed "s/:.*//" >"$CONFIG"/plugins.txt
echo "## Building plugins list done"
