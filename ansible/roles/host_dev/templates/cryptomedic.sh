#!/usr/bin/env bash

# Installed by ansible

set -o errexit

export JH_CRYPTOMEDIC_UPLOAD_USER="{{jehon.credentials.cryptomedic.upload_user}}"
export JH_CRYPTOMEDIC_UPLOAD_PASSWORD="{{jehon.credentials.cryptomedic.upload_password}}"
export JH_CRYPTOMEDIC_DB_UPGRADE="{{jehon.credentials.cryptomedic.db_upgrade}}"
