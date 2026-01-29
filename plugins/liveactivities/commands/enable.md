---
description: Enable Live Activities hooks (start sending to iOS)
---

Enable Live Activities to send hooks to your iOS device.

Execute this command:

```bash
CONFIG_FILE="${HOME}/.liveactivities/config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Live Activities: Not logged in"
  echo "Run /liveactivities:login first"
  exit 1
fi

# Update the config file - set LIVEACTIVITIES_ENABLED=true
if grep -q "^LIVEACTIVITIES_ENABLED=" "$CONFIG_FILE" 2>/dev/null; then
  sed -i '' 's/^LIVEACTIVITIES_ENABLED=.*/LIVEACTIVITIES_ENABLED="true"/' "$CONFIG_FILE"
else
  echo 'LIVEACTIVITIES_ENABLED="true"' >> "$CONFIG_FILE"
fi

echo "Live Activities: Enabled"
echo "Hooks will be sent to your iOS device"
```
