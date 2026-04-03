-- Search inbox for emails from a specific sender.
-- Usage: osascript search-by-sender.applescript "sender@example.com" [limit]
-- Returns: tab-separated lines of subject, sender, date received

on run argv
    set senderQuery to item 1 of argv
    if (count of argv) > 1 then
        set maxResults to (item 2 of argv) as integer
    else
        set maxResults to 10
    end if

    tell application "Mail"
        set matchingMsgs to (messages of inbox whose sender contains senderQuery)
        set msgCount to count of matchingMsgs
        if msgCount is 0 then return "No messages found from " & senderQuery
        if msgCount > maxResults then set msgCount to maxResults

        set output to ""
        repeat with i from 1 to msgCount
            set msg to item i of matchingMsgs
            try
                set output to output & subject of msg & tab & sender of msg & tab & (date received of msg as string) & linefeed
            end try
        end repeat
        return output
    end tell
end run
