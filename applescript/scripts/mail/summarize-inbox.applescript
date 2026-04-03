-- Summarize recent inbox: counts unread, flagged, and lists the most recent messages.
-- Usage: osascript summarize-inbox.applescript [limit]
-- Returns: summary stats followed by tab-separated message list

on run argv
    if (count of argv) > 0 then
        set maxResults to (item 1 of argv) as integer
    else
        set maxResults to 15
    end if

    tell application "Mail"
        with timeout of 120 seconds
            set unreadCount to count of (messages of inbox whose read status is false)
            set flaggedCount to count of (messages of inbox whose flagged status is true)
            set totalCount to count of messages of inbox

            set output to "Inbox: " & totalCount & " total, " & unreadCount & " unread, " & flaggedCount & " flagged" & linefeed & linefeed

            set recentMsgs to messages 1 thru maxResults of inbox
            repeat with msg in recentMsgs
                try
                    set readMarker to "  "
                    if read status of msg is false then set readMarker to "* "
                    set flagMarker to "  "
                    if flagged status of msg is true then set flagMarker to "! "

                    set output to output & readMarker & flagMarker & subject of msg & tab & sender of msg & tab & (date received of msg as string) & linefeed
                end try
            end repeat
            return output
        end timeout
    end tell
end run
