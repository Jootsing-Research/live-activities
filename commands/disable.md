---
description: Disable Hooky hooks (stop sending to iOS)
---

Disable Hooky to stop sending hooks to your iOS device. You'll stay logged in.

Execute this command:

```bash
CONFIG_FILE="${HOME}/.hooky/config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Hooky: Not logged in"
  echo "Nothing to disable"
  exit 0
fi

# Update the config file - set HOOKY_ENABLED=false
if grep -q "^HOOKY_ENABLED=" "$CONFIG_FILE" 2>/dev/null; then
  sed -i '' 's/^HOOKY_ENABLED=.*/HOOKY_ENABLED="false"/' "$CONFIG_FILE"
else
  echo 'HOOKY_ENABLED="false"' >> "$CONFIG_FILE"
fi

echo "Hooky: Disabled"
echo "Hooks will NOT be sent (still logged in)"
echo "Run /hooky:enable to turn back on"
```
