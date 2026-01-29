#!/bin/bash
#
# Live Activities CLI - iOS Live Activity notifications for Claude Code
# https://liveactivities.ai
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.liveactivities"
CONFIG_FILE="${CONFIG_DIR}/config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

show_help() {
    echo ""
    echo -e "${BLUE}${BOLD}Live Activities${NC} - iOS Live Activity notifications for Claude Code"
    echo ""
    echo "Usage: liveactivities <command>"
    echo ""
    echo "Commands:"
    echo "  login     Link your CLI to the Live Activities iOS app"
    echo "  logout    Unlink your CLI"
    echo "  status    Check if you're logged in"
    echo "  enable    Enable sending hooks to Live Activities"
    echo "  disable   Disable sending hooks (stays logged in)"
    echo "  help      Show this help message"
    echo ""
    echo "Get started:"
    echo "  1. Install the Live Activities iOS app"
    echo "  2. Run 'liveactivities login' and scan the QR code"
    echo "  3. Start a Live Activity in the app"
    echo "  4. Use Claude Code as normal - your iPhone will update!"
    echo ""
}

cmd_login() {
    "${SCRIPT_DIR}/liveactivities-login.sh"
}

cmd_logout() {
    if [ -f "$CONFIG_FILE" ]; then
        rm "$CONFIG_FILE"
        echo -e "${GREEN}✓ Logged out successfully${NC}"
    else
        echo -e "${YELLOW}You're not logged in${NC}"
    fi
}

cmd_status() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        if [ -n "$LIVEACTIVITIES_TOKEN" ]; then
            echo -e "${GREEN}✓ Logged in${NC}"
            if [ -n "$LIVEACTIVITIES_USER_ID" ]; then
                echo -e "  User ID: ${LIVEACTIVITIES_USER_ID:0:8}..."
            fi
            # Show enabled/disabled status (default is enabled)
            if [ "${LIVEACTIVITIES_ENABLED:-true}" = "true" ]; then
                echo -e "  Status: ${GREEN}enabled${NC}"
            else
                echo -e "  Status: ${YELLOW}disabled${NC}"
            fi
        else
            echo -e "${YELLOW}Not logged in${NC}"
            echo "  Run 'liveactivities login' to connect"
        fi
    else
        echo -e "${YELLOW}Not logged in${NC}"
        echo "  Run 'liveactivities login' to connect"
    fi
}

cmd_enable() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${YELLOW}Not logged in${NC}"
        echo "  Run 'liveactivities login' first"
        exit 1
    fi

    # Update the config file - set LIVEACTIVITIES_ENABLED=true
    if grep -q "^LIVEACTIVITIES_ENABLED=" "$CONFIG_FILE" 2>/dev/null; then
        # Replace existing value
        sed -i '' 's/^LIVEACTIVITIES_ENABLED=.*/LIVEACTIVITIES_ENABLED="true"/' "$CONFIG_FILE"
    else
        # Add new line
        echo 'LIVEACTIVITIES_ENABLED="true"' >> "$CONFIG_FILE"
    fi

    echo -e "${GREEN}✓ Live Activities enabled${NC}"
    echo "  Hooks will be sent to your iOS device"
}

cmd_disable() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${YELLOW}Not logged in${NC}"
        echo "  Run 'liveactivities login' first"
        exit 1
    fi

    # Update the config file - set LIVEACTIVITIES_ENABLED=false
    if grep -q "^LIVEACTIVITIES_ENABLED=" "$CONFIG_FILE" 2>/dev/null; then
        # Replace existing value
        sed -i '' 's/^LIVEACTIVITIES_ENABLED=.*/LIVEACTIVITIES_ENABLED="false"/' "$CONFIG_FILE"
    else
        # Add new line
        echo 'LIVEACTIVITIES_ENABLED="false"' >> "$CONFIG_FILE"
    fi

    echo -e "${YELLOW}⏸ Live Activities disabled${NC}"
    echo "  Hooks will NOT be sent (still logged in)"
}

# Main command handler
case "${1:-help}" in
    login)
        cmd_login
        ;;
    logout)
        cmd_logout
        ;;
    status)
        cmd_status
        ;;
    enable|on)
        cmd_enable
        ;;
    disable|off)
        cmd_disable
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
