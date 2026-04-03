-- Draft a new email. Opens the compose window for review — does NOT send.
-- Usage: osascript draft-new.applescript "recipient@example.com" "Subject line" "Body text"

on run argv
    set toAddr to item 1 of argv
    set msgSubject to item 2 of argv
    set msgBody to item 3 of argv

    tell application "Mail"
        set newMsg to make new outgoing message with properties {subject:msgSubject, content:msgBody, visible:true}
        tell newMsg
            make new to recipient at end of to recipients with properties {address:toAddr}
        end tell
        activate
        return "Draft created: " & msgSubject
    end tell
end run
