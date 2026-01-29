#!/bin/bash
#
# Live Activities - iOS Live Activity notifications for Claude Code
# https://liveactivities.ai
#

set -e

HOOK_NAME="$1"
CONFIG_FILE="${HOME}/.liveactivities/config"
SERVER_URL="${LIVEACTIVITIES_SERVER_URL:-https://liveactivities.ai}"

# Exit silently if not logged in
[ -f "$CONFIG_FILE" ] || exit 0

source "$CONFIG_FILE"

[ -z "$LIVEACTIVITIES_TOKEN" ] && exit 0

# Exit silently if disabled (default is enabled if not set)
[ "${LIVEACTIVITIES_ENABLED:-true}" = "false" ] && exit 0

# Send hook event to server (async, don't block Claude Code)
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${LIVEACTIVITIES_TOKEN}" \
    -d @- \
    "${SERVER_URL}/api/hooks/${HOOK_NAME}" \
    --max-time 10 \
    > /dev/null 2>&1

exit 0
