# Date Formatting Gotchas

AppleScript's `date` coercion parses strings according to the user's system locale.
The safest format that works across US/UK/international locales is:

```
Month Day, Year at Hour:Minute:Second AM/PM
```

Example: `"April 2, 2026 at 3:05:00 PM"`

### The Python `strftime` pattern

```python
dt.strftime("%B %-d, %Y at %-I:%M:%S %p")
```

| Directive | Produces       | Notes                              |
|-----------|----------------|------------------------------------|
| `%B`      | `April`        | Full month name                    |
| `%-d`     | `2`            | Day without zero-padding           |
| `%Y`      | `2026`         | Four-digit year                    |
| `%-I`     | `3`            | 12-hour clock without zero-padding |
| `%M`      | `05`           | Minutes (zero-padded is fine)      |
| `%S`      | `00`           | Seconds (zero-padded is fine)      |
| `%p`      | `PM`           | AM/PM                              |

### Why `%-d` and `%-I` are required

AppleScript's date parser on most macOS locale configurations **rejects
zero-padded** day and hour values in certain positions:

- `"April 02, 2026"` — fails because `02` is treated as ambiguous. AppleScript
  expects a bare `2`.
- `"April 2, 2026 at 03:05:00 PM"` — fails because `03` in 12-hour format is
  unexpected. AppleScript expects `3`.

The `%-d` and `%-I` format codes produce **unpadded** values (`2` instead of `02`,
`3` instead of `03`). This is a **GNU/macOS strftime extension** — it works on
macOS Python but is not portable to Windows (`%#d` is the Windows equivalent).

### What breaks if you zero-pad

| Input                                  | Result           |
|----------------------------------------|------------------|
| `date "April 2, 2026 at 3:05:00 PM"`  | Parses correctly |
| `date "April 02, 2026 at 3:05:00 PM"` | Error on most locales |
| `date "April 2, 2026 at 03:05:00 PM"` | Error on most locales |
| `date "04/02/2026 3:05 PM"`           | Locale-dependent — avoid |

### Full example

```python
from datetime import datetime

def format_applescript_date(iso_str: str) -> str:
    dt = datetime.fromisoformat(iso_str)
    return dt.strftime("%B %-d, %Y at %-I:%M:%S %p")

# Usage:
# format_applescript_date("2026-04-02T15:05:00") -> "April 2, 2026 at 3:05:00 PM"
# format_applescript_date("2026-12-25T09:00:00") -> "December 25, 2026 at 9:00:00 AM"
```
