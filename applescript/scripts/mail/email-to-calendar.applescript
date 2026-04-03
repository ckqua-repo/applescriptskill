-- Create a Calendar event from an email matching the given subject.
-- Usage: osascript email-to-calendar.applescript "subject" "start date" "end date" ["Calendar Name"]
-- Date format: "April 10, 2026 at 2:00:00 PM" (use the Python date helper to convert ISO dates)

on run argv
    set subjectQuery to item 1 of argv
    set startDateStr to item 2 of argv
    set endDateStr to item 3 of argv
    if (count of argv) > 3 then
        set calName to item 4 of argv
    else
        set calName to "Home"
    end if

    tell application "Mail"
        try
            set msg to first message of inbox whose subject contains subjectQuery
            set msgSubject to subject of msg
            set msgSender to sender of msg
            set msgBody to content of msg

            -- Truncate body for event notes (first 500 chars)
            if length of msgBody > 500 then
                set msgBody to text 1 thru 500 of msgBody & "..."
            end if

            set eventTitle to msgSubject
            set eventNotes to "From: " & msgSender & return & return & msgBody
        on error
            return "No message found matching '" & subjectQuery & "'"
        end try
    end tell

    tell application "Calendar"
        tell calendar calName
            set startDate to date startDateStr
            set endDate to date endDateStr
            make new event with properties {summary:eventTitle, start date:startDate, end date:endDate, description:eventNotes}
        end tell
        return "Event created: " & eventTitle & " on " & calName
    end tell
end run
