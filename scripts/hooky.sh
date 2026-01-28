#!/bin/bash
#
# Hooky - iOS Live Activity notifications for Claude Code
# https://dev-do-something.vercel.app
#
# This script sends Claude Code hook events to the Hooky server,
# which then updates your iPhone's Live Activity via push notification.
#

set -e

HOOK_NAME="$1"
CONFIG_DIR="${HOME}/.hooky"
CONFIG_FILE="${CONFIG_DIR}/config"
SERVER_URL="${HOOKY_SERVER_URL:-https://dev-do-something.vercel.app}"

# Read input from stdin (Claude Code passes JSON here)
INPUT=$(cat)

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    # Not logged in - silently exit (don't block Claude Code)
    exit 0
fi

# Read token from config
source "$CONFIG_FILE"

if [ -z "$HOOKY_TOKEN" ]; then
    exit 0
fi

# Send hook event to server (async, don't wait for response)
# Claude Code passes the payload as JSON via stdin - forward it directly
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${HOOKY_TOKEN}" \
    -d "${INPUT:-{}}" \
    "${SERVER_URL}/api/hooks/${HOOK_NAME}" \
    --max-time 5 \
    > /dev/null 2>&1 &

# Always exit successfully so we don't block Claude Code
exit 0
