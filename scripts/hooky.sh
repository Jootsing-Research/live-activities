#!/bin/bash
#
# Hooky - iOS Live Activity notifications for Claude Code
# https://dev-do-something.vercel.app
#

set -e

HOOK_NAME="$1"
CONFIG_FILE="${HOME}/.hooky/config"
SERVER_URL="${HOOKY_SERVER_URL:-https://dev-do-something.vercel.app}"

# Exit silently if not logged in
[ -f "$CONFIG_FILE" ] || exit 0

source "$CONFIG_FILE"

[ -z "$HOOKY_TOKEN" ] && exit 0

# Send hook event to server (async, don't block Claude Code)
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${HOOKY_TOKEN}" \
    -d @- \
    "${SERVER_URL}/api/hooks/${HOOK_NAME}" \
    --max-time 10 \
    > /dev/null 2>&1

exit 0
