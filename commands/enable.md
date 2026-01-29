---
description: Enable Hooky hooks (start sending to iOS)
---

Enable Hooky to send hooks to your iOS device.

Execute this command:

```bash
CONFIG_FILE="${HOME}/.hooky/config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Hooky: Not logged in"
  echo "Run /hooky:login first"
  exit 1
fi

# Update the config file - set HOOKY_ENABLED=true
if grep -q "^HOOKY_ENABLED=" "$CONFIG_FILE" 2>/dev/null; then
  sed -i '' 's/^HOOKY_ENABLED=.*/HOOKY_ENABLED="true"/' "$CONFIG_FILE"
else
  echo 'HOOKY_ENABLED="true"' >> "$CONFIG_FILE"
fi

echo "Hooky: Enabled"
echo "Hooks will be sent to your iOS device"
```
