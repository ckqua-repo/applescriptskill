# Calendar

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
