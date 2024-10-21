#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\CursorHandler.ahk
#Include Lib\CustomMsgbox.ahk
#Include Lib\ToolTipEx.ahk
#Include Lib\ColorSchemes.ahk

; Variables (keeping original variables)
ErrorTimer := 1
EDIT_Y_AXIS := 80
TEXT_Y_AXIS := EDIT_Y_AXIS + 3
btnY := EDIT_Y_AXIS + 33
fadeSteps := 10
fadeInterval := 100
currentOpacity := 255
FF_ERROR := A_ScriptDir "\Lib\Icons\FF_Error.png"
FF_STOP := A_ScriptDir "\Lib\Icons\FF_Stop.png"
FF_INFO := A_ScriptDir "\Lib\Icons\FF_Info.png"
FF_QUESTION := A_ScriptDir "\Lib\Icons\FF_Question.png"

; Create the main GUI window
tCal := GuiExt("AlwaysOnTop", "Time to Hours Calculator")

tCal.SetDarkTitle()
tCal.SetDarkMenu()

; Store text controls for color updates
textControls := []

; Select random scheme at startup
randomScheme := ColorSchemes.Schemes[Random(1, ColorSchemes.Schemes.Length)]

; Function to update GUI colors
UpdateColors(scheme) {
    bgColor := scheme.bg
    fontColor := scheme.font
    btnColor := scheme.btn
    
    ; Update GUI background
    tCal.BackColor := bgColor
    
    ; Update button colors
    calculatePatternBtn.SetColor(btnColor, fontColor, 0, 0, 9)
    calculateFieldsBtn.SetColor(btnColor, fontColor, 0, 0, 9)
    
    ; Update text controls
    for ctrl in textControls {
        ctrl.Opt("c" fontColor)
    }
    
    ; Keep result text color as is for visibility
    resultText.Opt("c48ff00")
}

; Add color schemes
CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")

; Pattern input section
tCal.SetFont("s10 Bold cwhite", "JetBrains Mono")
patternText := tCal.AddText("x10 y10", "Enter time in format HH:MM:SS (e.g., 34:03:11)")
timeEdit := tCal.AddEdit("x10 y30 w390 c313131", "")

; Individual fields section
separateText := tCal.AddText("x10 y" (TEXT_Y_AXIS - 25), "Enter values separately")

tCal.Add("Text", "x10 y" TEXT_Y_AXIS, "Hours:")
hoursEdit := tCal.AddEdit("Limit2 Number x60 y" EDIT_Y_AXIS " w60 vHours c313131")

tCal.Add("Text", "x" 10 + 120 " y" TEXT_Y_AXIS, "Minutes:")
minutesEdit := tCal.AddEdit("Limit2 Number x" 60 + 140 " y" EDIT_Y_AXIS " w60 vMinutes c313131")

tCal.Add("Text", "x" 10 + 120 + 140 " y" TEXT_Y_AXIS, "Seconds:")
secondsEdit := tCal.AddEdit("Limit2 Number x" 60 + 140 + 140 " y" EDIT_Y_AXIS " w60 vSeconds c313131")

; Add calculate buttons
calculatePatternBtn := tCal.AddButton("x10 y" btnY " w140", "Calculate from Pattern")
calculateFieldsBtn := tCal.AddButton("x160 y" btnY " w140", "Calculate from Fields")

; Result display
tCal.SetFont("s10 Bold c48ff00", "JetBrains Mono")
resultText := tCal.AddText("x310 y" 115 " w80")

; Rest of the original functions
TimeToHours(hours, minutes, seconds) {
    totalHours := hours + (minutes / 60) + (seconds / 3600)
    return Round(totalHours, 2)
}

ParseTimePattern(timeStr) {
    if !RegExMatch(timeStr, "^\d+:\d{2}:\d{2}$") {
        throw Error("Invalid time format. Please use HH:MM:SS")
    }

    timeParts := StrSplit(timeStr, ":")
    hours := Number(timeParts[1])
    minutes := Number(timeParts[2])
    seconds := Number(timeParts[3])

    if (minutes >= 60 || seconds >= 60) {
        throw Error("Minutes and seconds must be less than 60")
    }

    return TimeToHours(hours, minutes, seconds)
}

CalculateFromPattern(*) {
    timePattern := timeEdit.Value

    if (timePattern = "") {
        ShowError("Please enter a time pattern")
        return
    }

    try {
        total := ParseTimePattern(timePattern)
        ShowResult(total)
        timeEdit.Value := ""
        timeEdit.Focus()
    } catch as err {
        ShowError(err.Message)
        timeEdit.Focus()
    }
}

CalculateFromFields(*) {
    try {
        hours := Number(hoursEdit.Value)
        minutes := Number(minutesEdit.Value)
        seconds := Number(secondsEdit.Value)

        if (minutes >= 60 || seconds >= 60) {
            throw Error("Minutes and seconds must be less than 60")
        }

        total := TimeToHours(hours, minutes, seconds)
        ShowResult(total)

        hoursEdit.Value := ""
        minutesEdit.Value := ""
        secondsEdit.Value := ""
        hoursEdit.Focus()
    } catch as err {
        ShowError("Please enter valid numbers for all fields")
    }
}

ShowError(message) {
    TraySetIcon(FF_STOP)
    msg := CustomMsgBox()
    msg.SetText("Error", message)
    msg.SetPosition(240, 118)
    msg.SetColorScheme("Error")
    msg.SetOptions("ToolWindow", "AlwaysOnTop")
    msg.SetCloseTimer(ErrorTimer)
    msg.Show()
}

ShowResult(total) {
    global currentOpacity, resultText
    
    currentOpacity := 255
    resultText.Value := Format("{1} hours", total)
    A_Clipboard := total
    
    resultText.Value := Format("{1} hours", total)
    ToolTipEX("Result copied to clipboard!", 1)
    
    SetTimer FadeOut, fadeInterval
}

FadeOut() {
    global currentOpacity, fadeSteps, fadeInterval, resultText
    
    currentOpacity -= 255 / fadeSteps
    
    if (currentOpacity <= 0) {
        SetTimer(FadeOut, 0)
        resultText.Value := ""
        currentOpacity := 255
        return
    }
    
    color := Format("c{:02x}{:02x}{:02x}", currentOpacity, currentOpacity, currentOpacity)
    resultText.SetFont(color)
}

; Button event handlers
calculatePatternBtn.OnEvent("Click", CalculateFromPattern)
calculateFieldsBtn.OnEvent("Click", CalculateFromFields)

; Enter key handlers
timeEdit.OnEvent("Change", CheckEnterPattern)
secondsEdit.OnEvent("Change", CheckEnterFields)

CheckEnterPattern(*) {
    if GetKeyState("Enter", "P")
        CalculateFromPattern()
}

CheckEnterFields(*) {
    if GetKeyState("Enter", "P")
        CalculateFromFields()
}

; Initial color scheme application
UpdateColors(randomScheme)

; Show the GUI
tCal.Show("Center")