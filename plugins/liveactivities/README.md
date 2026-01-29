# Live Activities - Claude Code Plugin

iOS Live Activity notifications for Claude Code. Know when Claude needs you.

<p align="center">
  <img src="https://liveactivities.ai/screenshots/dynamic-island-expanded.png" width="250" />
  <img src="https://liveactivities.ai/screenshots/live-activity-lockscreen-feed.png" width="250" />
  <img src="https://liveactivities.ai/screenshots/dynamic-island-compact-homescreen.png" width="250" />
</p>

## What is Live Activities?

Live Activities sends real-time updates to your iPhone when Claude Code:
- Starts or stops working
- Needs your permission
- Asks you a question
- Completes a task
- Hits an error

Updates appear on your **Lock Screen** and **Dynamic Island** via iOS Live Activities.

## Prerequisites

- **Live Activities iOS app** - Download from the App Store
- **Claude Code** - Version 1.0.0 or later
- **macOS or Linux** - curl must be available

## Installation

Install from the Claude Code plugin marketplace:

```
/plugin marketplace add jootsing-research/jootsing-plugins
/plugin install liveactivities@jootsing-plugins
```

## Setup

### 1. Login to Live Activities

In Claude Code, run:

```
/liveactivities:login
```

This will display a code. Enter it in the Live Activities iOS app to link your device.

### 2. Start a Live Activity

Open the Live Activities iOS app and tap "Start Live Activity".

### 3. Use Claude Code

That's it! Your iPhone will now show Live Activity updates as you use Claude Code.

## Commands

| Command | Description |
|---------|-------------|
| `/liveactivities:login` | Link your CLI to the iOS app |
| `/liveactivities:logout` | Unlink your CLI |
| `/liveactivities:status` | Check if you're logged in and enabled/disabled |
| `/liveactivities:enable` | Enable sending hooks to your iOS device |
| `/liveactivities:disable` | Disable sending hooks (stays logged in) |

### Enabling/Disabling Hooks

You can temporarily disable Live Activities without logging out. This is useful when:
- Working on multiple repos but only want notifications for some
- Testing or debugging without constant notifications
- Pausing notifications temporarily

```
/liveactivities:disable   # Stop sending hooks
/liveactivities:enable    # Resume sending hooks
```

You'll stay logged in, so you can quickly re-enable without scanning the QR code again.

## How It Works

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Claude Code │────▶│    Live     │────▶│    Live     │────▶│   iPhone    │
│   (Hooks)   │     │  Activities │     │  Activities │     │Live Activity│
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

1. **Claude Code** fires hook events during operation
2. **Live Activities Plugin** captures events and sends to server
3. **Live Activities Server** processes events and sends push notification
4. **iPhone** receives push and updates Live Activity

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LIVEACTIVITIES_SERVER_URL` | Server URL | `https://liveactivities.ai` |

### Config File

Credentials and settings are stored in `~/.liveactivities/config`:

```bash
LIVEACTIVITIES_TOKEN="your-auth-token"
LIVEACTIVITIES_USER_ID="your-user-id"
LIVEACTIVITIES_ENABLED="true"  # or "false" to disable
```

When `LIVEACTIVITIES_ENABLED` is not set, it defaults to `true` (enabled).

## Troubleshooting

### Live Activity not updating?

1. Make sure you've started a Live Activity in the iOS app
2. Check that Live Activities are enabled in iOS Settings
3. Verify you're logged in: `/liveactivities:status`
4. Check that hooks are registered: `/hooks` in Claude Code

## Privacy & Security

- Auth tokens are stored locally in `~/.liveactivities/config`
- Only hook metadata is sent to the server (no file contents)
- All communication is over HTTPS
- You can revoke access anytime with `/liveactivities:logout`

## Uninstallation

```
/plugin uninstall liveactivities@jootsing-plugins
/plugin marketplace remove jootsing-plugins
```

To also remove local config:

```bash
rm -rf ~/.liveactivities
```

## Support

- Website: https://liveactivities.ai
- Issues: https://github.com/jootsing-research/jootsing-plugins/issues

## License

MIT License - see LICENSE file for details.
