# Script Authoring Guide

How to create, save, and verify reusable `.applescript` files that other agents
(or this agent in future sessions) can run directly.

## When to Create a Script

Save a new `.applescript` file when:

- The task is **discrete and reusable** (e.g., "search mail by sender" vs. a one-off query)
- The task involves **multiple steps or apps** (e.g., read email → create reminder)
- The user will likely **repeat this operation** with different arguments
- The AppleScript is **more than ~5 lines** and benefits from being a named, documented file

Do **not** create a script for:

- True one-off operations the user won't repeat
- Simple single-line commands (use inline `osascript -e` instead)

## File Conventions

### Naming

- **Kebab-case**: `search-by-sender.applescript`, `email-to-reminder.applescript`
- Name describes the action: `verb-noun` or `verb-preposition-noun`
- Extension: `.applescript` (plain text, git-friendly)

### Placement

Save under `scripts/<app>/` where `<app>` matches the primary application:

```
scripts/
├── mail/
│   ├── search-by-sender.applescript
│   └── draft-reply.applescript
├── reminders/
│   └── create-with-date.applescript
├── calendar/
│   └── create-event.applescript
└── notes/
    └── create-note.applescript
```

For cross-app scripts, place under the **source** app (the one providing input).
Example: `email-to-reminder.applescript` lives in `scripts/mail/` because it
reads from Mail.

## Comment Header

Every script must start with a comment header. This is how agents discover what
a script does and how to call it:

```applescript
-- Short description of what this script does.
-- Usage: osascript scripts/<app>/<name>.applescript "required-arg" ["optional-arg"]
-- Returns: description of stdout output format
```

Rules:
- First line: one-sentence description
- `Usage:` line: full command with argument placeholders. Wrap optional args in `[]`
- `Returns:` line: describe the output format (e.g., "tab-separated lines of subject, sender, date")

## Script Skeleton

Use this as a starting point for new scripts:

```applescript
-- Description of what this script does.
-- Usage: osascript scripts/<app>/<name>.applescript "arg1" ["optional-arg"]
-- Returns: description of output format

on run argv
    -- Parse required arguments
    if (count of argv) < 1 then
        return "Error: missing required argument. Usage: osascript <script> \"arg1\""
    end if
    set firstArg to item 1 of argv

    -- Parse optional arguments with defaults
    if (count of argv) > 1 then
        set optionalArg to (item 2 of argv) as integer
    else
        set optionalArg to 10
    end if

    tell application "TargetApp"
        try
            -- Core logic here
            set results to (messages of inbox whose sender contains firstArg)
            set resultCount to count of results
            if resultCount is 0 then return "No results found"
            if resultCount > optionalArg then set resultCount to optionalArg

            -- Build structured output
            set output to ""
            repeat with i from 1 to resultCount
                set item_ to item i of results
                try
                    set output to output & (property1 of item_) & tab & (property2 of item_) & linefeed
                end try
            end repeat
            return output
        on error errMsg number errNum
            return "Error " & errNum & ": " & errMsg
        end try
    end tell
end run
```

### Key patterns in the skeleton

| Pattern | Why |
|---------|-----|
| Argument count check | Fail fast with a usage hint instead of a cryptic error |
| Type coercion (`as integer`) | Arguments arrive as strings — coerce explicitly |
| Default values for optional args | Scripts should work with minimal input |
| `whose` filtering | Faster than iterating — filters at the app level |
| Result limiting | Prevents timeouts on large containers |
| `try`/`on error` around core logic | Catches missing objects, permission errors, timeouts |
| Inner `try` in repeat loop | One bad item doesn't abort the whole loop |
| Tab-separated output with linefeed | Consistent, parseable format across all scripts |
| Return on empty results | Human-readable message instead of blank output |

## Output Conventions

All scripts in this skill follow these output rules:

- **Field separator**: `tab`
- **Record separator**: `linefeed`
- **Empty results**: Return a human-readable message (e.g., `"No messages found"`)
- **Errors**: Return `"Error: "` followed by the message
- **Success for write operations**: Return a confirmation string (e.g., `"Reminder created: Follow up on invoice"`)

This lets the agent parse output reliably regardless of which script was called.

## Cross-App Scripts

When a script bridges two apps (e.g., read from Mail, write to Reminders):

1. **Separate the tell blocks** — one per app, sequential:

```applescript
-- Read from source app
tell application "Mail"
    try
        set msg to first message of inbox whose subject contains subjectQuery
        set msgSubject to subject of msg
        set msgSender to sender of msg
        set msgBody to content of msg
    on error
        return "No message found matching '" & subjectQuery & "'"
    end try
end tell

-- Write to target app
tell application "Reminders"
    make new reminder in list "Reminders" with properties {name:reminderName, body:reminderBody}
    return "Reminder created: " & reminderName
end tell
```

2. **Extract data into variables** between tell blocks — don't nest tells across apps
3. **Truncate long text** (email bodies) before storing in the target app — 500 chars is a good limit
4. **Handle errors per app** — a Mail lookup failure shouldn't leave a half-created Reminder

See `scripts/mail/email-to-reminder.applescript` and `scripts/mail/email-to-calendar.applescript`
for working examples of this pattern.

## Verification Checklist

After creating a new script, the agent must verify it before considering the task complete:

1. **Run with valid arguments** — confirm it produces expected output
   ```bash
   osascript scripts/<app>/<name>.applescript "test-arg"
   ```

2. **Run with edge cases** — confirm graceful handling:
   - Missing or empty arguments → should return a usage hint or error message
   - No matching results → should return a human-readable "not found" message
   - If the script accepts a limit, test with `1` to confirm limiting works

3. **Check the comment header** — verify it accurately describes:
   - What the script does
   - The exact arguments and their order
   - What the output looks like

4. **Confirm the file location** — script is saved under the correct `scripts/<app>/` directory

If any verification step fails, fix the script and re-run. Do not report success
to the user until all steps pass.
