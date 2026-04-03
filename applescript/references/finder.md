# Finder

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
