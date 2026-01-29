#!/bin/bash
#
# Hooky Login - Link your CLI to your Hooky iOS app
# https://liveactivities.ai
#
# This script creates a link request that you scan with the Hooky iOS app.
#

set -e

CONFIG_DIR="${HOME}/.hooky"
CONFIG_FILE="${CONFIG_DIR}/config"
SERVER_URL="${HOOKY_SERVER_URL:-https://liveactivities.ai}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo ""
echo -e "${BLUE}${BOLD}  ╭─────────────────────────────────────╮${NC}"
echo -e "${BLUE}${BOLD}  │           🪝 Hooky Login            │${NC}"
echo -e "${BLUE}${BOLD}  │   iOS Live Activity for Claude Code │${NC}"
echo -e "${BLUE}${BOLD}  ╰─────────────────────────────────────╯${NC}"
echo ""

# Check if already logged in
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    if [ -n "$HOOKY_TOKEN" ]; then
        echo -e "${YELLOW}You're already logged in.${NC}"
        echo ""
        read -p "Do you want to re-authenticate? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
fi

# Create config directory
mkdir -p "$CONFIG_DIR"

echo -e "${BOLD}Creating link request...${NC}"
echo ""

# Get device name (hostname)
DEVICE_NAME=$(hostname 2>/dev/null || echo "CLI Device")

# Create link request with device info
RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "{\"device_name\": \"${DEVICE_NAME}\"}" \
    "${SERVER_URL}/api/auth/link/create")

# Parse response - try jq first, fall back to Python, then grep
parse_json() {
    local key="$1"
    local json="$2"

    if command -v jq &> /dev/null; then
        echo "$json" | jq -r ".$key // empty"
    elif command -v python3 &> /dev/null; then
        echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('$key',''))"
    else
        echo "$json" | grep -o "\"$key\":\"[^\"]*\"" | cut -d'"' -f4
    fi
}

TOKEN=$(parse_json "token" "$RESPONSE")
CODE=$(parse_json "code" "$RESPONSE")
QR_DATA=$(parse_json "qr_data" "$RESPONSE")

if [ -z "$TOKEN" ] || [ -z "$CODE" ]; then
    echo -e "${RED}Failed to create link request. Please try again.${NC}"
    echo "Response: $RESPONSE"
    exit 1
fi

echo -e "${BOLD}Scan this QR code with the Hooky iOS app:${NC}"
echo ""

# Try to display QR code in terminal
if command -v qrencode &> /dev/null; then
    echo "$QR_DATA" | qrencode -t ANSIUTF8
elif command -v python3 &> /dev/null; then
    python3 -c "
import sys
try:
    import qrcode
    qr = qrcode.QRCode(border=1)
    qr.add_data('$QR_DATA')
    qr.print_ascii(invert=True)
except ImportError:
    print('Open the Hooky iOS app and scan or enter code manually')
" 2>/dev/null || {
    echo -e "Open the Hooky iOS app and scan or enter code manually"
}
else
    echo -e "Open the Hooky iOS app and enter the code manually"
fi

echo ""
echo -e "${BOLD}Verification code: ${GREEN}${CODE}${NC}"
echo ""
echo -e "${YELLOW}Waiting for you to scan with the Hooky app...${NC}"
echo -e "(Press Ctrl+C to cancel)"
echo ""

# Poll for claim status
MAX_ATTEMPTS=60  # 5 minutes (5 second intervals)
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    STATUS_RESPONSE=$(curl -s "${SERVER_URL}/api/auth/link/status/${TOKEN}")
    STATUS=$(parse_json "status" "$STATUS_RESPONSE")

    if [ "$STATUS" = "claimed" ]; then
        # Get the auth token from the response
        AUTH_TOKEN=$(parse_json "authToken" "$STATUS_RESPONSE")
        USER_ID=$(parse_json "userId" "$STATUS_RESPONSE")

        if [ -n "$AUTH_TOKEN" ]; then
            # Save to config
            echo "HOOKY_TOKEN=\"${AUTH_TOKEN}\"" > "$CONFIG_FILE"
            echo "HOOKY_USER_ID=\"${USER_ID}\"" >> "$CONFIG_FILE"
            chmod 600 "$CONFIG_FILE"

            echo ""
            echo -e "${GREEN}${BOLD}✓ Successfully linked!${NC}"
            echo ""
            echo -e "Your Claude Code sessions will now update your iPhone's Live Activity."
            echo -e "Make sure to start a Live Activity in the Hooky app first."
            echo ""
            exit 0
        else
            echo ""
            echo -e "${RED}Linked but failed to get auth token. Please try again.${NC}"
            exit 1
        fi
    elif [ "$STATUS" = "expired" ]; then
        echo ""
        echo -e "${RED}Link request expired. Please try again.${NC}"
        exit 1
    fi

    sleep 5
    ATTEMPT=$((ATTEMPT + 1))
done

echo ""
echo -e "${RED}Timed out waiting for scan. Please try again.${NC}"
exit 1
