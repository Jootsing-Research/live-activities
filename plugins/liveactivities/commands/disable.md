---
description: Disable Live Activities hooks (stop sending to iOS)
---

Disable Live Activities to stop sending hooks to your iOS device. You'll stay logged in.

Execute this command:

```bash
CONFIG_FILE="${HOME}/.liveactivities/config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Live Activities: Not logged in"
  echo "Nothing to disable"
  exit 0
fi

# Update the config file - set LIVEACTIVITIES_ENABLED=false
if grep -q "^LIVEACTIVITIES_ENABLED=" "$CONFIG_FILE" 2>/dev/null; then
  sed -i '' 's/^LIVEACTIVITIES_ENABLED=.*/LIVEACTIVITIES_ENABLED="false"/' "$CONFIG_FILE"
else
  echo 'LIVEACTIVITIES_ENABLED="false"' >> "$CONFIG_FILE"
fi

echo "Live Activities: Disabled"
echo "Hooks will NOT be sent (still logged in)"
echo "Run /liveactivities:enable to turn back on"
```
