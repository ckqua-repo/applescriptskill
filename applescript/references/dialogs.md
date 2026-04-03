# Dialogs

### OK / Cancel dialog

```applescript
display dialog "Do you want to continue?" buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
```

### Text input dialog

```applescript
set userInput to text returned of (display dialog "Enter your name:" default answer "" buttons {"Cancel", "OK"} default button "OK")
return userInput
```

### Custom buttons dialog

```applescript
set choice to button returned of (display dialog "Choose an option:" buttons {"Option A", "Option B", "Option C"} default button "Option A")
return choice
```

### Warning alert

```applescript
display alert "Warning" message "This action cannot be undone. Proceed?" as warning buttons {"Cancel", "Delete"} default button "Cancel" cancel button "Cancel"
```

### Choose from list

```applescript
set selectedItem to choose from list {"Red", "Green", "Blue"} with prompt "Pick a color:" default items {"Red"}
if selectedItem is false then
    return "User cancelled"
else
    return item 1 of selectedItem
end if
```
