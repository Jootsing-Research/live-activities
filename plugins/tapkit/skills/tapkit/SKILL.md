---
name: tapkit
description: This skill should be used when the user wants to "control my iPhone", "take a screenshot of my phone", "tap on the screen", "open an app", "type on my phone", or interact with a physical iPhone through TapKit MCP tools.
---

# TapKit — iPhone Control

You have access to a physical iPhone through TapKit MCP tools. You can see the screen via screenshots and interact through taps, swipes, typing, and other gestures.

## Setup

If only one phone is connected, it's auto-selected — just start using tools directly (e.g. `screenshot`). If multiple phones are connected, call `list_phones` then `select_phone` with the ID you want.

## Use Tools First, Navigate Second

Always prefer a direct tool over manual navigation:

- **Opening apps**: call `open_app("Settings")` — don't scroll through home screens looking for the icon
- **Searching the phone**: call `spotlight("calculator")` — don't swipe down and hunt visually
- **Going home**: call `press_home` — don't swipe up from the bottom

Only use tap/swipe navigation for things **inside** an app where no tool shortcut exists.

## Core Loop

Your workflow is always: **screenshot → look → act → screenshot to verify**.

1. Take a `screenshot` to see what's on screen
2. Visually identify the element you need to interact with
3. Estimate the pixel coordinates of its **center**
4. Call the appropriate tool (tap, swipe, type_text, etc.)
5. Take another `screenshot` to confirm the action worked
6. If it didn't work, try a different approach

**Always screenshot before and after actions.** You have no other way to see the phone — no accessibility tree, no DOM, no element selectors. Everything is visual + coordinates.

## Coordinate System

Screenshots are resized so you see them at the same resolution as the coordinate space. **Coordinates map 1:1 with screenshot pixels** — if an element is at pixel (300, 672) in the image, tap (300, 672). The dimensions are returned by `select_phone` and `get_phone_info` (typically around 618x1344).

- (0, 0) is the top-left corner
- x increases rightward, y increases downward
- Aim for the **center** of UI elements — iOS touch targets can be small
- The status bar is roughly the top 47px, the home indicator bar is the bottom ~37px

## Tools Quick Reference

### Navigation
- `open_app(app_name)` — Open any app by name (e.g. "Settings", "Safari", "Hinge")
- `press_home` — Go to home screen
- `escape` — Dismiss keyboards, alerts, popups, or go back in navigation
- `spotlight(query?)` — Open Spotlight search, optionally type a query

### Touch Gestures
- `tap(x, y)` — Single tap. Use for buttons, links, icons, list items
- `double_tap(x, y)` — Double tap. Use for zooming or text selection
- `long_press(x, y, duration?)` — Tap and hold. Opens context menus. Default 1000ms
- `swipe(x, y, direction)` — Fast flick gesture at a point. Direction: "up", "down", "left", "right". Use for dismissing, switching pages, scrolling
- `drag(from_x, from_y, to_x, to_y)` — Drag from one point to another. Use for sliders, precise scrolling, moving items
- `hold_and_drag(from_x, from_y, to_x, to_y, hold_duration_ms?)` — Long press then drag. Use for drag-and-drop, reordering lists

### Input
- `type_text(text)` — Type into the currently focused text field. **You must tap the field first** to focus it before typing
- `activate_siri` — Trigger Siri voice assistant

### Device
- `screenshot` — Get current screen as an image
- `get_phone_info` — Get screen dimensions and device name
- `lock` / `unlock` — Lock or unlock the screen
- `volume_up` / `volume_down` — Volume controls
- `run_shortcut(index)` — Run an iOS Shortcut by its index number

## iOS Navigation Tips

- **Scroll down**: `swipe(300, 672, "down")` — flick downward from screen center
- **Go back** in an app: look for a "< Back" arrow in the top-left and tap it, or `swipe(10, 672, "right")` (left-edge swipe)
- **Dismiss a modal/popup**: look for "X", "Cancel", "Done", or tap outside it
- **Pull to refresh**: `drag(300, 200, 300, 600)` (drag down from top of content area)
- **Switch apps**: `swipe(300, 1300, "up")` (swipe up from bottom)
- **Close keyboard**: tap anywhere outside the keyboard, or `press_home`
- **Tab bars** at the bottom of apps are the main navigation — tap the icons to switch sections
- **iOS alerts** (permissions, confirmations) appear as centered popups — tap "Allow", "OK", etc.

## Text Input

1. **Tap the text field** first — look for the keyboard to appear at the bottom
2. If no keyboard appears, the field isn't focused — tap it again
3. Call `type_text(text)` to enter text
4. To submit: tap the blue button on the keyboard (it says "Search", "Go", "Send", or "Done" depending on context). It's usually in the bottom-right area of the keyboard
5. To clear a field: triple-tap to select all, then `type_text` with the new value

## Common Patterns

**Opening an app:**
```
open_app("Settings") → screenshot to verify it opened
```

**Searching within an app:**
```
tap the search field → type_text("query") → tap the Search button on keyboard → screenshot
```

**Scrolling through a list:**
```
swipe(300, 672, "down") → screenshot → look for target → repeat if needed
```

**Handling a popup/alert:**
```
screenshot → identify the popup → tap the appropriate button (Allow, OK, Cancel, etc.)
```

## Important

- **Be precise with coordinates.** Off by 50px can mean tapping the wrong element
- **Always verify with screenshots.** Never assume an action succeeded
- **Apps take 1-2 seconds to load.** If a screenshot looks unchanged after tapping an app icon, take another screenshot — it may still be loading
- **If something doesn't work after 2-3 tries, try a different approach.** Don't keep tapping the same spot
- **You cannot handle Face ID, CAPTCHAs, or biometric prompts.** Tell the user if you encounter these
- **Don't type passwords** unless the user explicitly provided them in their request
