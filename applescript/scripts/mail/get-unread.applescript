-- Get unread emails from inbox.
-- Usage: osascript get-unread.applescript [limit]
-- Returns: tab-separated lines of subject, sender, date received

on run argv
    if (count of argv) > 0 then
        set maxResults to (item 1 of argv) as integer
    else
        set maxResults to 15
    end if

    tell application "Mail"
        set unreadMsgs to (messages of inbox whose read status is false)
        set msgCount to count of unreadMsgs
        if msgCount is 0 then return "No unread messages"
        if msgCount > maxResults then set msgCount to maxResults

        set output to ""
        repeat with i from 1 to msgCount
            set msg to item i of unreadMsgs
            try
                set output to output & subject of msg & tab & sender of msg & tab & (date received of msg as string) & linefeed
            end try
        end repeat
        return output
    end tell
end run
