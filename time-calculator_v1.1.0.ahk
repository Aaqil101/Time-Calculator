#Requires AutoHotkey v2.0

; Create the main GUI window
MyGui := Gui(, "Time to Hours Calculator")

; Create input boxes with better alignment
MyGui.Add("Text", "x10 y10", "Hours:")
hoursEdit := MyGui.Add("Edit", "x70 y8 w60 vHours")

MyGui.Add("Text", "x140 y10", "Minutes:")
minutesEdit := MyGui.Add("Edit", "x200 y8 w60 vMinutes")

MyGui.Add("Text", "x270 y10", "Seconds:")
secondsEdit := MyGui.Add("Edit", "x330 y8 w60 vSeconds")

; Add calculate button
calculateBtn := MyGui.Add("Button", "x10 y40 w100", "Calculate")

; Add result text with better positioning
resultText := MyGui.Add("Text", "x120 y43 w200")

; Function to convert time to hours
TimeToHours(hours, minutes, seconds) {
    totalHours := hours + (minutes / 60) + (seconds / 3600)
    return Round(totalHours, 2)  ; Round to 2 decimal places
}

; Button click event handler
calculateBtn.OnEvent("Click", Calculate)

Calculate(*) {
    ; Get values from input boxes
    hours := Number(hoursEdit.Value)
    minutes := Number(minutesEdit.Value)
    seconds := Number(secondsEdit.Value)
    
    ; Validate input
    if (hours = "" || minutes = "" || seconds = "") {
        MsgBox "Please enter valid numbers for all fields"
        return
    }
    
    ; Calculate total hours
    total := TimeToHours(hours, minutes, seconds)
    
    ; Display result
    resultText.Value := Format("{1} hours", total)
    
    ; Copy result to clipboard
    A_Clipboard := total
    
    ; Clear input boxes
    hoursEdit.Value := ""
    minutesEdit.Value := ""
    secondsEdit.Value := ""
    
    ; Set focus back to hours input
    hoursEdit.Focus()
}

; Show the GUI
MyGui.Show()
