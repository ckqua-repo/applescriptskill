# AppleScript Reference Patterns

Vetted, copy-paste-ready snippets for common macOS automation tasks.

## Table of Contents

- [Notification Center](#notification-center)
- [Reminders](#reminders)
- [Calendar](#calendar)
- [Notes](#notes)
- [Clipboard](#clipboard)
- [Dialogs](#dialogs)
- [System Events / UI Scripting](#system-events--ui-scripting)
- [Finder](#finder)
- [Mail](#mail)
- [Date Formatting Gotchas](#date-formatting-gotchas)

---

## Notification Center

### Display a notification

```applescript
display notification "Build completed successfully" with title "CI Pipeline" subtitle "All 42 tests passed" sound name "Glass"
```

The `subtitle` and `sound name` parameters are optional. Common sound names:
`"Basso"`, `"Blow"`, `"Bottle"`, `"Frog"`, `"Funk"`, `"Glass"`, `"Hero"`,
`"Morse"`, `"Ping"`, `"Pop"`, `"Purr"`, `"Sosumi"`, `"Submarine"`, `"Tink"`.

---

## Reminders

### Create a reminder (no due date)

```applescript
tell application "Reminders"
    make new reminder in list "Reminders" with properties {name:"Buy groceries", body:"Milk, eggs, bread"}
end tell
```

### Create a reminder with a due date

```applescript
tell application "Reminders"
    set dueDate to date "April 5, 2026 at 9:00:00 AM"
    make new reminder in list "Reminders" with properties {name:"Submit report", due date:dueDate}
end tell
```

### List incomplete reminders

```applescript
tell application "Reminders"
    set output to ""
    repeat with r in (reminders in list "Reminders" whose completed is false)
        set output to output & name of r & linefeed
    end repeat
    return output
end tell
```

### Mark a reminder complete

```applescript
tell application "Reminders"
    set targetReminder to (first reminder in list "Reminders" whose name is "Buy groceries")
    set completed of targetReminder to true
end tell
```

### List all reminder lists

```applescript
tell application "Reminders"
    set output to ""
    repeat with l in lists
        set output to output & name of l & linefeed
    end repeat
    return output
end tell
```

---

## Calendar

### Create an event (basic)

```applescript
tell application "Calendar"
    tell calendar "Home"
        set startDate to date "April 10, 2026 at 2:00:00 PM"
        set endDate to date "April 10, 2026 at 3:00:00 PM"
        make new event with properties {summary:"Team standup", start date:startDate, end date:endDate}
    end tell
end tell
```

### Create an event with notes and location

```applescript
tell application "Calendar"
    tell calendar "Work"
        set startDate to date "April 12, 2026 at 10:00:00 AM"
        set endDate to date "April 12, 2026 at 11:30:00 AM"
        make new event with properties {summary:"Design review", start date:startDate, end date:endDate, location:"Conference Room B", description:"Review Q2 mockups with design team"}
    end tell
end tell
```

### List all calendars

```applescript
tell application "Calendar"
    set output to ""
    repeat with c in calendars
        set output to output & name of c & linefeed
    end repeat
    return output
end tell
```

### Get today's events

```applescript
tell application "Calendar"
    set todayStart to current date
    set time of todayStart to 0
    set todayEnd to todayStart + (1 * days)
    set output to ""
    repeat with c in calendars
        repeat with e in (events of c whose start date >= todayStart and start date < todayEnd)
            set output to output & summary of e & " at " & start date of e & linefeed
        end repeat
    end repeat
    return output
end tell
```

---

## Notes

### Create a note in the default account

```applescript
tell application "Notes"
    tell account "iCloud"
        make new note at folder "Notes" with properties {name:"Meeting Notes", body:"<h1>Meeting Notes</h1><p>Discussion points go here.</p>"}
    end tell
end tell
```

Note: The `body` property accepts HTML. Use `<h1>`, `<p>`, `<ul>`, `<li>`, etc.

### Create a note in a specific folder

```applescript
tell application "Notes"
    tell account "iCloud"
        make new note at folder "Work" with properties {name:"Project Ideas", body:"Brainstorm list"}
    end tell
end tell
```

If the folder doesn't exist, create it first:

```applescript
tell application "Notes"
    tell account "iCloud"
        make new folder with properties {name:"Work"}
        make new note at folder "Work" with properties {name:"Project Ideas", body:"Brainstorm list"}
    end tell
end tell
```

### Append to an existing note

```applescript
tell application "Notes"
    tell account "iCloud"
        set targetNote to first note in folder "Notes" whose name is "Meeting Notes"
        set body of targetNote to (body of targetNote) & "<p>New paragraph appended.</p>"
    end tell
end tell
```

### Search notes by title

```applescript
tell application "Notes"
    set output to ""
    repeat with n in (notes whose name contains "Project")
        set output to output & name of n & linefeed
    end repeat
    return output
end tell
```

---

## Clipboard

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

---

## Dialogs

### OK / Cancel dialog

```applescript
display dialog "Do you want to continue?" buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
```

### Text input dialog

```applescript
set userInput to text returned of (display dialog "Enter your name:" default answer "" buttons {"Cancel", "OK"} default button "OK")
return userInput
```

### Custom buttons dialog

```applescript
set choice to button returned of (display dialog "Choose an option:" buttons {"Option A", "Option B", "Option C"} default button "Option A")
return choice
```

### Warning alert

```applescript
display alert "Warning" message "This action cannot be undone. Proceed?" as warning buttons {"Cancel", "Delete"} default button "Cancel" cancel button "Cancel"
```

### Choose from list

```applescript
set selectedItem to choose from list {"Red", "Green", "Blue"} with prompt "Pick a color:" default items {"Red"}
if selectedItem is false then
    return "User cancelled"
else
    return item 1 of selectedItem
end if
```

---

## System Events / UI Scripting

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

---

## Finder

### Get the home folder path

```applescript
set homePath to POSIX path of (path to home folder)
return homePath
```

### Open a folder

```applescript
tell application "Finder"
    open folder "Documents" of home
    activate
end tell
```

### List files in a folder

```applescript
tell application "Finder"
    set fileList to name of every file of folder "Documents" of home
    set output to ""
    repeat with f in fileList
        set output to output & f & linefeed
    end repeat
    return output
end tell
```

### Move a file to Trash

```applescript
tell application "Finder"
    move file "OldFile.txt" of folder "Documents" of home to trash
end tell
```

---

## Mail

### Create a draft email

```applescript
tell application "Mail"
    set newMessage to make new outgoing message with properties {subject:"Weekly Update", content:"Hi team,\n\nHere is this week's update.\n\nBest regards", visible:true}
    tell newMessage
        make new to recipient at end of to recipients with properties {address:"team@example.com"}
    end tell
    activate
end tell
```

Setting `visible:true` opens the compose window for review. The message is **not**
sent until the user clicks Send (or the script calls `send`).

### Send an email immediately

```applescript
tell application "Mail"
    set newMessage to make new outgoing message with properties {subject:"Automated Alert", content:"Disk usage exceeded 90%."}
    tell newMessage
        make new to recipient at end of to recipients with properties {address:"admin@example.com"}
    end tell
    send newMessage
end tell
```

### Search the inbox

```applescript
tell application "Mail"
    set matchingMessages to (messages of inbox whose subject contains "invoice")
    set output to ""
    repeat with m in matchingMessages
        set output to output & subject of m & " — from: " & sender of m & linefeed
    end repeat
    return output
end tell
```

---

## Date Formatting Gotchas

AppleScript's `date` coercion parses strings according to the user's system locale.
The safest format that works across US/UK/international locales is:

```
Month Day, Year at Hour:Minute:Second AM/PM
```

Example: `"April 2, 2026 at 3:05:00 PM"`

### The Python `strftime` pattern

```python
dt.strftime("%B %-d, %Y at %-I:%M:%S %p")
```

| Directive | Produces       | Notes                              |
|-----------|----------------|------------------------------------|
| `%B`      | `April`        | Full month name                    |
| `%-d`     | `2`            | Day without zero-padding           |
| `%Y`      | `2026`         | Four-digit year                    |
| `%-I`     | `3`            | 12-hour clock without zero-padding |
| `%M`      | `05`           | Minutes (zero-padded is fine)      |
| `%S`      | `00`           | Seconds (zero-padded is fine)      |
| `%p`      | `PM`           | AM/PM                              |

### Why `%-d` and `%-I` are required

AppleScript's date parser on most macOS locale configurations **rejects
zero-padded** day and hour values in certain positions:

- `"April 02, 2026"` — fails because `02` is treated as ambiguous. AppleScript
  expects a bare `2`.
- `"April 2, 2026 at 03:05:00 PM"` — fails because `03` in 12-hour format is
  unexpected. AppleScript expects `3`.

The `%-d` and `%-I` format codes produce **unpadded** values (`2` instead of `02`,
`3` instead of `03`). This is a **GNU/macOS strftime extension** — it works on
macOS Python but is not portable to Windows (`%#d` is the Windows equivalent).

### What breaks if you zero-pad

| Input                                  | Result           |
|----------------------------------------|------------------|
| `date "April 2, 2026 at 3:05:00 PM"`  | Parses correctly |
| `date "April 02, 2026 at 3:05:00 PM"` | Error on most locales |
| `date "April 2, 2026 at 03:05:00 PM"` | Error on most locales |
| `date "04/02/2026 3:05 PM"`           | Locale-dependent — avoid |

### Full example

```python
from datetime import datetime

def format_applescript_date(iso_str: str) -> str:
    dt = datetime.fromisoformat(iso_str)
    return dt.strftime("%B %-d, %Y at %-I:%M:%S %p")

# Usage:
# format_applescript_date("2026-04-02T15:05:00") -> "April 2, 2026 at 3:05:00 PM"
# format_applescript_date("2026-12-25T09:00:00") -> "December 25, 2026 at 9:00:00 AM"
```
