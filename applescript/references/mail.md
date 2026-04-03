# Mail

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
