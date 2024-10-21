#Requires AutoHotkey v2.0

; Create the main GUI window
MyGui := Gui(, "Time to Hours Calculator")

; Add input boxes with labels
MyGui.Add("Text", , "Hours:")
hoursEdit := MyGui.Add("Edit", "w60 vHours")
MyGui.Add("Text", "x+10", "Minutes:")
minutesEdit := MyGui.Add("Edit", "w60 vMinutes")
MyGui.Add("Text", "x+10", "Seconds:")
secondsEdit := MyGui.Add("Edit", "w60 vSeconds")

; Add calculate button
calculateBtn := MyGui.Add("Button", "x10 y+10 w100", "Calculate")

; Add result text
resultText := MyGui.Add("Text", "x+10 yp+5 w200")

; Function to convert time to hours
TimeToHours(hours, minutes, seconds) {
    totalHours := hours + (minutes / 60) + (seconds / 3600)
    return Round(totalHours, 4)
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
}

; Show the GUI
MyGui.Show()
