# System Events / UI Scripting

**Prerequisite**: The calling application must have Accessibility access enabled
in System Settings > Privacy & Security > Accessibility.

### Click a menu item

```applescript
tell application "System Events"
    tell process "Finder"
        click menu item "New Finder Window" of menu "File" of menu bar 1
    end tell
end tell
```

### Type text into the frontmost app

```applescript
tell application "System Events"
    keystroke "Hello, world!"
end tell
```

### Key combinations

```applescript
-- Command+C (copy)
tell application "System Events"
    keystroke "c" using command down
end tell

-- Command+Shift+S (save as)
tell application "System Events"
    keystroke "s" using {command down, shift down}
end tell

-- Press Return
tell application "System Events"
    key code 36
end tell
```

### Get the frontmost application name

```applescript
tell application "System Events"
    set frontApp to name of first application process whose frontmost is true
    return frontApp
end tell
```
