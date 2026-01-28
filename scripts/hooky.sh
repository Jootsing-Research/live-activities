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

# Save stdin to a temp file to avoid shell expansion issues with special chars
TMPFILE=$(mktemp)
trap "rm -f $TMPFILE" EXIT
cat > "$TMPFILE"

# Send hook event to server (async, don't wait for response)
# Use --data-binary with file to preserve JSON exactly as received
curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${HOOKY_TOKEN}" \
    --data-binary "@${TMPFILE}" \
    "${SERVER_URL}/api/hooks/${HOOK_NAME}" \
    --max-time 5 \
    > /dev/null 2>&1 &

# Always exit successfully so we don't block Claude Code
exit 0
