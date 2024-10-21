#Requires AutoHotkey v2.0

; Modern GUI Styles Library
class ModernStyles {
    static BackColor := "FFFFFF"  ; White background
    static TextColor := "000000"  ; Black text
    static AccentColor := "4CAF50"  ; Material Green
    static Gray := "E0E0E0"  ; Light gray for borders
    
    static StyleEdit(ctl) {
        ctl.SetFont("s10", "Segoe UI")
        ctl.OnEvent("Focus", ObjBindMethod(this, "EditFocus"))
        ctl.OnEvent("LoseFocus", ObjBindMethod(this, "EditLoseFocus"))
    }
    
    static StyleButton(ctl) {
        ctl.SetFont("s10", "Segoe UI")
        ctl.OnEvent("Focus", ObjBindMethod(this, "ButtonFocus"))
        ctl.OnEvent("LoseFocus", ObjBindMethod(this, "ButtonLoseFocus"))
    }
    
    static EditFocus(ctl, *) {
        this.DrawBorder(ctl.Hwnd, this.AccentColor)
    }
    
    static EditLoseFocus(ctl, *) {
        this.DrawBorder(ctl.Hwnd, this.Gray)
    }
    
    static ButtonFocus(ctl, *) {
        this.DrawBorder(ctl.Hwnd, this.AccentColor)
    }
    
    static ButtonLoseFocus(ctl, *) {
        this.DrawBorder(ctl.Hwnd, this.Gray)
    }
    
    static DrawBorder(hwnd, color) {
        color := "0x" . color
        RECT := Buffer(16)
        DllCall("GetClientRect", "Ptr", hwnd, "Ptr", RECT)
        hDC := DllCall("GetDC", "Ptr", hwnd)
        pen := DllCall("CreatePen", "Int", 0, "Int", 2, "UInt", color)
        DllCall("SelectObject", "Ptr", hDC, "Ptr", pen)
        DllCall("Rectangle", "Ptr", hDC, "Int", 0, "Int", 0, "Int", NumGet(RECT, 8, "Int"), "Int", NumGet(RECT, 12, "Int"))
        DllCall("DeleteObject", "Ptr", pen)
        DllCall("ReleaseDC", "Ptr", hwnd, "Ptr", hDC)
    }
}

; Window dimensions
windowWidth := 440
windowHeight := 180
padding := 20

; Calculate positions
headerHeight := 40
inputRowY := headerHeight + padding
buttonRowY := inputRowY + 40

; Input field dimensions
labelWidth := 60
editWidth := 60
editHeight := 25
groupSpacing := 30

; Calculate positions for each input group
totalInputWidth := (labelWidth + editWidth) * 3 + groupSpacing * 2
startX := (windowWidth - totalInputWidth) // 2

; Create the main GUI window
MyGui := Gui("+AlwaysOnTop -Caption +Border")

; Add title bar
MyGui.SetFont("s12 Bold", "Segoe UI")
titleBar := MyGui.Add("Text", Format("x{1} y{2} w{3} h{4}", padding, padding/2, windowWidth-padding*2, headerHeight), "Time to Hours Calculator")

; Create input boxes with perfect alignment
MyGui.SetFont("s10", "Segoe UI")

; Hours group
hoursLabelX := startX
hoursEditX := hoursLabelX + labelWidth
MyGui.Add("Text", Format("x{1} y{2}", hoursLabelX, inputRowY+3), "Hours:")
hoursEdit := MyGui.Add("Edit", Format("x{1} y{2} w{3} h{4}", hoursEditX, inputRowY, editWidth, editHeight), "")
ModernStyles.StyleEdit(hoursEdit)

; Minutes group
minutesLabelX := hoursEditX + editWidth + groupSpacing
minutesEditX := minutesLabelX + labelWidth
MyGui.Add("Text", Format("x{1} y{2}", minutesLabelX, inputRowY+3), "Minutes:")
minutesEdit := MyGui.Add("Edit", Format("x{1} y{2} w{3} h{4}", minutesEditX, inputRowY, editWidth, editHeight), "")
ModernStyles.StyleEdit(minutesEdit)

; Seconds group
secondsLabelX := minutesEditX + editWidth + groupSpacing
secondsEditX := secondsLabelX + labelWidth
MyGui.Add("Text", Format("x{1} y{2}", secondsLabelX, inputRowY+3), "Seconds:")
secondsEdit := MyGui.Add("Edit", Format("x{1} y{2} w{3} h{4}", secondsEditX, inputRowY, editWidth, editHeight), "")
ModernStyles.StyleEdit(secondsEdit)

; Calculate button and result positioning
buttonWidth := 100
buttonHeight := 30
buttonX := (windowWidth - buttonWidth) // 2
resultTextWidth := 200

calculateBtn := MyGui.Add("Button", Format("x{1} y{2} w{3} h{4}", buttonX, buttonRowY, buttonWidth, buttonHeight), "Calculate")
ModernStyles.StyleButton(calculateBtn)

; Result text centered below button
resultTextX := (windowWidth - resultTextWidth) // 2
resultText := MyGui.Add("Text", Format("x{1} y{2} w{3} h{4} Center", resultTextX, buttonRowY + buttonHeight + padding/2, resultTextWidth, 25), "")
resultText.SetFont("s10", "Segoe UI")

; Add a close button in the top right
closeBtn := MyGui.Add("Button", Format("x{1} y{2} w30 h20", windowWidth-50, padding/2), "×")
closeBtn.OnEvent("Click", (*) => ExitApp())
ModernStyles.StyleButton(closeBtn)

; Make window draggable
OnMessage(0x201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    static HTCAPTION := 2
    if (hwnd = MyGui.Hwnd)
        PostMessage(0xA1, HTCAPTION)
}

; Function to convert time to hours
TimeToHours(hours, minutes, seconds) {
    totalHours := hours + (minutes / 60) + (seconds / 3600)
    return Round(totalHours, 2)
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
    
    ; Show tooltip indicating copy
    ToolTip "Result copied to clipboard!"
    SetTimer () => ToolTip(), -1000
    
    ; Clear input boxes
    hoursEdit.Value := ""
    minutesEdit.Value := ""
    secondsEdit.Value := ""
    
    ; Set focus back to hours input
    hoursEdit.Focus()
}

; Show the GUI centered
MyGui.Show(Format("w{1} h{2}", windowWidth, windowHeight))