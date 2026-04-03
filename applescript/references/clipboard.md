# Clipboard

### Read clipboard contents

```applescript
the clipboard
```

### Write to clipboard

```applescript
set the clipboard to "Hello from AppleScript"
```

### Safe clipboard read (with fallback)

```applescript
try
    set clipContent to the clipboard as text
    return clipContent
on error
    return "clipboard is empty or contains non-text data"
end try
```
