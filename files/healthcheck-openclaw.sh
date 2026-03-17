#!/usr/bin/env bash
set -e -o pipefail

curl --fail --location http://localhost:18789/healthz || exit 1
