# Reminders

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
