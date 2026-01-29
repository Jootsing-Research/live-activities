---
description: Link your CLI to the Live Activities iOS app
---

Run the Live Activities login script to link this CLI to your iPhone. This will display a QR code that you scan with the Live Activities iOS app.

Execute this command:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/liveactivities-login.sh"
```

After running, tell the user to:
1. Open the Live Activities iOS app
2. Scan the QR code (or enter the code manually)
3. Wait for confirmation

The script will automatically save the auth token when linking succeeds.
