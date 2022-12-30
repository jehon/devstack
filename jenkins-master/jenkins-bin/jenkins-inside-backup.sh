#!/usr/bin/env bash

set -o errexit

find "$JENKINS_EXPORT" -mindepth 1 -delete || true

echo "## Testing connectivity..."
jenkins-inside-cli.sh "who-am-i"
echo "## Testing connectivity done"

echo "## Building plugins list..."
(
    # unused-TODO: use method described here for generating plugin.txt
    # https://github.com/jenkinsci/docker/blob/master/README.md

    cat <<"EOS" | jenkins-inside-cli.sh groovy "="
import jenkins.model.Jenkins;

Jenkins.instance.pluginManager.plugins
    .collect()
    .sort { it.getShortName() }
    .each {
        plugin -> println("${plugin.getShortName()}:${plugin.getVersion()}")
    }
EOS

) | sed "s/:.*//" >"$JENKINS_EXPORT"/plugins.txt
echo "## Building plugins list done"

echo "## Backup raw data..."
mkdir -p "$EXPORT/raw"
rsync --prune-empty-dirs --archive \
    --exclude "changelog.xml" --exclude "builds" \
    --include="*.xml" --include="*/" \
    --exclude="*" \
    "$JENKINS_HOME/jobs" "$JENKINS_EXPORT/raw"

rsync --prune-empty-dirs --archive \
    "$JENKINS_HOME/nodes" "$JENKINS_EXPORT/raw"

cp "$JENKINS_HOME/"*.xml "$JENKINS_EXPORT/raw"
echo "## Backup raw data done"
