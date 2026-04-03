-- Read the full content of a specific email by subject match.
-- Usage: osascript read-email.applescript "exact or partial subject"
-- Returns: subject, sender, date, and full plain-text body

on run argv
    set subjectQuery to item 1 of argv

    tell application "Mail"
        try
            set msg to first message of inbox whose subject contains subjectQuery
            set msgSubject to subject of msg
            set msgSender to sender of msg
            set msgDate to date received of msg as string
            set msgBody to content of msg

            return "Subject: " & msgSubject & linefeed & "From: " & msgSender & linefeed & "Date: " & msgDate & linefeed & linefeed & msgBody
        on error
            return "No message found matching '" & subjectQuery & "'"
        end try
    end tell
end run
