# Notes

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
