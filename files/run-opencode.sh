#!/usr/bin/env bash
set -e -o pipefail

su user --login --command "opencode web --hostname 0.0.0.0 --port 11003"
