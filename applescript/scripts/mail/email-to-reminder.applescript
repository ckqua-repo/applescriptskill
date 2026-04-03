-- Create a Reminder from an email matching the given subject.
-- Usage: osascript email-to-reminder.applescript "subject to match" ["AppleScript date string"]
-- Date format: "April 5, 2026 at 9:00:00 AM" (use the Python date helper to convert ISO dates)

on run argv
    set subjectQuery to item 1 of argv
    if (count of argv) > 1 then
        set dueDateStr to item 2 of argv
    else
        set dueDateStr to ""
    end if

    tell application "Mail"
        try
            set msg to first message of inbox whose subject contains subjectQuery
            set msgSubject to subject of msg
            set msgSender to sender of msg
            set msgBody to content of msg

            -- Truncate body for reminder notes (first 500 chars)
            if length of msgBody > 500 then
                set msgBody to text 1 thru 500 of msgBody & "..."
            end if

            set reminderName to "Follow up: " & msgSubject
            set reminderBody to "From: " & msgSender & return & return & msgBody
        on error
            return "No message found matching '" & subjectQuery & "'"
        end try
    end tell

    tell application "Reminders"
        if dueDateStr is not "" then
            set dueDate to date dueDateStr
            make new reminder in list "Reminders" with properties {name:reminderName, body:reminderBody, due date:dueDate}
        else
            make new reminder in list "Reminders" with properties {name:reminderName, body:reminderBody}
        end if
        return "Reminder created: " & reminderName
    end tell
end run
