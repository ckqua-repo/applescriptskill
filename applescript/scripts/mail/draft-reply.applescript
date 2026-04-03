-- Draft a reply to an email matching the given subject.
-- Opens the compose window for review — does NOT send.
-- Usage: osascript draft-reply.applescript "subject to match" "reply body text"

on run argv
    set subjectQuery to item 1 of argv
    set replyBody to item 2 of argv

    tell application "Mail"
        try
            set origMsg to first message of inbox whose subject contains subjectQuery
            set origSubject to subject of origMsg
            set origSender to sender of origMsg
            set origContent to content of origMsg

            -- Build reply subject
            if origSubject does not start with "Re: " then
                set replySubject to "Re: " & origSubject
            else
                set replySubject to origSubject
            end if

            -- Build reply body with quoted original
            set replyContent to replyBody & linefeed & linefeed & "---Original Message---" & linefeed & "From: " & origSender & linefeed & linefeed & origContent

            -- Extract email address from sender string
            set replyAddr to origSender
            if replyAddr contains "<" then
                set AppleScript's text item delimiters to "<"
                set parts to every text item of replyAddr
                set AppleScript's text item delimiters to ">"
                set replyAddr to first text item of item 2 of parts
                set AppleScript's text item delimiters to ""
            end if

            set replyMsg to make new outgoing message with properties {subject:replySubject, content:replyContent, visible:true}
            tell replyMsg
                make new to recipient at end of to recipients with properties {address:replyAddr}
            end tell
            activate
            return "Draft reply opened for: " & origSubject
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
