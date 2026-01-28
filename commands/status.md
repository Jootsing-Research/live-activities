---
description: Check if you're logged into Hooky
---

Check the Hooky login status by looking for the config file.

Execute this command:

```bash
if [ -f "${HOME}/.hooky/config" ]; then
  echo "Hooky: Logged in"
  source "${HOME}/.hooky/config"
  if [ -n "$HOOKY_USER_ID" ]; then
    echo "User ID: ${HOOKY_USER_ID:0:8}..."
  fi
else
  echo "Hooky: Not logged in"
  echo "Run /hooky:login to connect"
fi
```
