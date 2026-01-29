---
description: Link your CLI to the Hooky iOS app for Live Activity notifications
---

Run the Hooky login script to link this CLI to your iPhone. This will display a QR code that you scan with the Hooky iOS app.

Execute this command:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/liveactivities-login.sh"
```

After running, tell the user to:
1. Open the Hooky iOS app
2. Scan the QR code (or enter the code manually)
3. Wait for confirmation

The script will automatically save the auth token when linking succeeds.
