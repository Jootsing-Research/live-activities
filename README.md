# Hooky - Claude Code Plugin

iOS Live Activity notifications for Claude Code. Know when Claude needs you.

## What is Hooky?

Hooky sends real-time updates to your iPhone when Claude Code:
- Starts or stops working
- Needs your permission
- Asks you a question
- Completes a task
- Hits an error

Updates appear on your **Lock Screen** and **Dynamic Island** via iOS Live Activities.

## Prerequisites

- **Hooky iOS app** - Download from the App Store
- **Claude Code** - Version 1.0.0 or later
- **macOS or Linux** - curl must be available

## Installation

### Option 1: Install as Claude Code Plugin (Recommended)

```bash
# Clone the plugin
git clone https://github.com/Jootsing-Research/hooky.git ~/.claude/plugins/hooky

# Or download just the plugin folder
curl -L https://github.com/Jootsing-Research/hooky/releases/latest/download/plugin.tar.gz | tar -xz -C ~/.claude/plugins/
```

Then enable it in your Claude Code settings:

```bash
claude
/plugin enable hooky
```

### Option 2: Manual Hook Configuration

Add to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{ "hooks": [{ "type": "command", "command": "~/.hooky/hooky.sh SessionStart" }] }],
    "PreToolUse": [{ "matcher": "*", "hooks": [{ "type": "command", "command": "~/.hooky/hooky.sh PreToolUse" }] }],
    "PostToolUse": [{ "matcher": "*", "hooks": [{ "type": "command", "command": "~/.hooky/hooky.sh PostToolUse" }] }],
    "Stop": [{ "hooks": [{ "type": "command", "command": "~/.hooky/hooky.sh Stop" }] }],
    "Notification": [{ "matcher": "*", "hooks": [{ "type": "command", "command": "~/.hooky/hooky.sh Notification" }] }],
    "SessionEnd": [{ "hooks": [{ "type": "command", "command": "~/.hooky/hooky.sh SessionEnd" }] }]
  }
}
```

## Setup

### 1. Login to Hooky

In Claude Code, run:

```
/hooky:login
```

This will display a QR code. Scan it with the Hooky iOS app.

### 2. Start a Live Activity

Open the Hooky iOS app and tap "Start Live Activity".

### 3. Use Claude Code

That's it! Your iPhone will now show Live Activity updates as you use Claude Code.

## Commands

| Command | Description |
|---------|-------------|
| `/hooky:login` | Link your CLI to the iOS app (shows QR code) |
| `/hooky:logout` | Unlink your CLI |
| `/hooky:status` | Check if you're logged in |

## How It Works

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Claude Code │────▶│   Hooky     │────▶│   Hooky     │────▶│  iPhone     │
│   (Hooks)   │     │   Plugin    │     │   Server    │     │ Live Activity│
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

1. **Claude Code** fires hook events during operation
2. **Hooky Plugin** captures events and sends to server
3. **Hooky Server** processes events and sends push notification
4. **iPhone** receives push and updates Live Activity

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `HOOKY_SERVER_URL` | Server URL | `https://dev-do-something.vercel.app` |

### Config File

Credentials are stored in `~/.hooky/config`:

```bash
HOOKY_TOKEN="your-auth-token"
HOOKY_USER_ID="your-user-id"
```

## Troubleshooting

### Live Activity not updating?

1. Make sure you've started a Live Activity in the iOS app
2. Check that Live Activities are enabled in iOS Settings
3. Verify you're logged in: `/hooky:status`
4. Check that hooks are registered: `/hooks` in Claude Code

### QR code not scanning?

Make sure you're using the Hooky iOS app (not your camera app).

### Permission errors?

Make sure the scripts are executable:

```bash
chmod +x ~/.claude/plugins/hooky/scripts/*.sh
```

## Privacy & Security

- Auth tokens are stored locally in `~/.hooky/config`
- Only hook metadata is sent to the server (no file contents)
- All communication is over HTTPS
- You can revoke access anytime with `/hooky:logout`

## Uninstallation

```bash
# Remove plugin
rm -rf ~/.claude/plugins/hooky

# Remove config
rm -rf ~/.hooky

# Disable in Claude Code
claude
/plugin disable hooky
```

## Support

- Website: https://dev-do-something.vercel.app
- Issues: https://github.com/Jootsing-Research/hooky/issues

## License

MIT License - see LICENSE file for details.
