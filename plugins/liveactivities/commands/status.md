---
description: Check if you're logged into Live Activities
---

Check the Live Activities login status by looking for the config file.

Execute this command:

```bash
if [ -f "${HOME}/.liveactivities/config" ]; then
  source "${HOME}/.liveactivities/config"
  if [ -n "$LIVEACTIVITIES_TOKEN" ]; then
    echo "Live Activities: Logged in"
    if [ -n "$LIVEACTIVITIES_USER_ID" ]; then
      echo "User ID: ${LIVEACTIVITIES_USER_ID:0:8}..."
    fi
    if [ "${LIVEACTIVITIES_ENABLED:-true}" = "true" ]; then
      echo "Status: enabled"
    else
      echo "Status: disabled (run /liveactivities:enable to turn on)"
    fi
  else
    echo "Live Activities: Not logged in"
    echo "Run /liveactivities:login to connect"
  fi
else
  echo "Live Activities: Not logged in"
  echo "Run /liveactivities:login to connect"
fi
```
