#!/usr/bin/env bash
set -e -o pipefail

cd /media/user

SIGNAL_HTTP_URL="$SIGNAL_SERVER_URL"
if [[ -z "$SIGNAL_HOME_CHANNEL" ]]; then
    SIGNAL_HOME_CHANNEL="${SIGNAL_ALLOWED_USERS%%,*}"
fi

export SIGNAL_HOME_CHANNEL SIGNAL_HTTP_URL

su user --whitelist-environment \
    SIGNAL_ACCOUNT,SIGNAL_ALLOWED_USERS,SIGNAL_GROUP_ALLOWED_USERS,SIGNAL_HOME_CHANNEL,SIGNAL_HTTP_URL \
    --command \
    "hermes config set model.default '$AI_MODEL' \
    && hermes config set model.provider container-config \
    && hermes config set model.context_length '$AI_CONTEXT_LENGTH' \
    && hermes config set providers.container-config.base_url '$AI_API_URL' \
    && hermes config set providers.container-config.api_key '$AI_API_KEY' \
    && hermes config set providers.container-config.default_model '$AI_MODEL' \
    && hermes config set providers.container-config.request_timeout_seconds '$AI_REQUEST_TIMEOUT' \
    && hermes config set providers.container-config.stale_timeout_seconds '$AI_REQUEST_TIMEOUT' \
    && hermes config set web.search_backend brave-free"

cat > /media/user/.hermes/.env <<EOF
BRAVE_SEARCH_API_KEY=$BRAVE_API_KEY
HERMES_STREAM_READ_TIMEOUT=$AI_REQUEST_TIMEOUT
HERMES_STREAM_STALE_TIMEOUT=$AI_REQUEST_TIMEOUT
EOF

chown user:user /media/user/.hermes/.env
chmod 600 /media/user/.hermes/.env

exec su user --command "hermes gateway run"
