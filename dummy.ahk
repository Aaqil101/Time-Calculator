/************************************************************************
 * @description Converts hours, minutes, and seconds into hours using two input methods.
 * @license GPL-3.0
 * @file time-calculator.ahk
 * @author Original: Aaqil Ilyas, Modified by Claude
 * @link (https://github.com/Aaqil101/FF-Creation)
 * @created 2024-10-20
 * @version 1.2.2
 * @copyright 2024 Aaqil Ilyas
 **************************************************************************/

#Requires Autohotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance Force ;Only launch anstance of this script.
Persistent ;Will keep it running

; Set the default mouse speed to 0
; This will make the mouse move instantly to its destination
; without any acceleration or deceleration
SetDefaultMouseSpeed 0

/*
* Include the GuiEnhancerKit library, which provides a set of functions to enhance the look and feel of AutoHotkey GUIs.
* For more information, see https://github.com/nperovic/GuiEnhancerKit

* Include the ColorButton library, which allows you to create custom buttons.
* For more information, see https://github.com/nperovic/ColorButton.ahk

* Include the CursorHandler library, which allows you to handle cursors.
* For more information, see https://www.youtube.com/watch?v=jn83VAU3tBw

* Include the CustomMsgbox library, which allows you to create custom message boxes.
* For more information, see https://github.com/Aaqil101/Custom-Libraries/tree/master/Custom%20Msgbox

* Include the ToolTipEx library, which allows you to create custom tooltips.
* For more information, see https://github.com/nperovic/ToolTipEx
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\CursorHandler.ahk
#Include Lib\CustomMsgbox.ahk
#Include Lib\ToolTipEx.ahk

; Variables
ErrorTimer := 1
EDIT_Y_AXIS := 80
TEXT_Y_AXIS := EDIT_Y_AXIS + 3
btnY := EDIT_Y_AXIS + 33
fadeSteps := 10  ; Number of fade steps
fadeInterval := 100  ; Milliseconds between each fade step (100ms * 10 steps = 1 second total)
currentOpacity := 255  ; Start with full opacity
bgColor := "313131"
FF_ERROR := A_ScriptDir "\Lib\Icons\FF_Error.png"
FF_STOP := A_ScriptDir "\Lib\Icons\FF_Stop.png"
FF_INFO := A_ScriptDir "\Lib\Icons\FF_Info.png"
FF_QUESTION := A_ScriptDir "\Lib\Icons\FF_Question.png"

CustomMsgBox.AddColorScheme("Error", "FF0000", "FFFFFF", "d46666")

; Create the main GUI window
tCal := GuiExt("AlwaysOnTop", "Time to Hours Calculator")

tCal.SetDarkTitle()
tCal.SetDarkMenu()
tCal.BackColor := bgColor

; Pattern input section
tCal.SetFont("s10 Bold cwhite", "JetBrains Mono")
tCal.AddText("x10 y10", "Enter time in format HH:MM:SS (e.g., 34:03:11)")
timeEdit := tCal.AddEdit("x10 y30 w390 c" bgColor, "")

tCal.SetFont("s10 Bold cwhite", "JetBrains Mono")

; Individual fields section
tCal.AddText("x10 y" (TEXT_Y_AXIS - 25), "Enter values separately")

tCal.Add("Text", "x10 y" TEXT_Y_AXIS, "Hours:")
hoursEdit := tCal.AddEdit("x60 y" EDIT_Y_AXIS " w60 vHours c" bgColor)

tCal.Add("Text", "x" 10 + 120 " y" TEXT_Y_AXIS, "Minutes:")
minutesEdit := tCal.AddEdit("Number x" 60 + 140 " y" EDIT_Y_AXIS " w60 vMinutes c" bgColor)

tCal.Add("Text", "x" 10 + 120 + 140 " y" TEXT_Y_AXIS, "Seconds:")
secondsEdit := tCal.AddEdit("Number x" 60 + 140 + 140 " y" EDIT_Y_AXIS " w60 vSeconds c" bgColor)

; Add calculate buttons for both methods
calculatePatternBtn := tCal.AddButton("x10 y" btnY " w140", "Calculate from Pattern")
calculatePatternBtn.SetColor("008080", "FBFADA", 0, 0, 9)

calculateFieldsBtn := tCal.AddButton("x160 y" btnY " w140", "Calculate from Fields")
calculateFieldsBtn.SetColor("008080", "FBFADA", 0, 0, 9)

; Result display
tCal.SetFont("s10 Bold c48ff00", "JetBrains Mono")
resultText := tCal.AddText("x310 y" 115 " w100")

; Function to convert time to hours
TimeToHours(hours, minutes, seconds) {
    totalHours := hours + (minutes / 60) + (seconds / 3600)
    return Round(totalHours, 2)
}

; Function to parse time pattern and convert to hours
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

; Handle pattern calculation
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

; Handle individual fields calculation
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

; Helper function to show errors
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

; Helper function to show and copy results
ShowResult(total) {
    global currentOpacity, resultText
    
    ; Reset opacity to full
    currentOpacity := 255
    resultText.Value := Format("{1} hours", total)
    A_Clipboard := total

    resultText.Value := Format("{1} hours", total)
    ToolTipEX("Result copied to clipboard!", 1)

    ; Start fade timer
    SetTimer FadeOut, fadeInterval
}

; Fade timer
FadeOut() {
    global currentOpacity, fadeSteps, fadeInterval, resultText
    
    ; Reduce opacity
    currentOpacity -= 255 / fadeSteps
    
    if (currentOpacity <= 0) {
        ; Stop the timer when fully faded
        SetTimer(FadeOut, 0)
        resultText.Value := ""  ; Clear the text
        currentOpacity := 255  ; Reset opacity for next time
        return
    }
    
    ; Apply the new opacity using RGB values
    color := Format("c{:02x}{:02x}{:02x}", currentOpacity, currentOpacity, currentOpacity)
    resultText.SetFont(color)
}

; Button click event handlers
calculatePatternBtn.OnEvent("Click", CalculateFromPattern)
calculateFieldsBtn.OnEvent("Click", CalculateFromFields)

/* ; Hotkey for paste in pattern field
#HotIf WinActive("Time to Hours Calculator")
^v::PasteTimePattern */

PasteTimePattern(*) {
    if (A_Clipboard ~= "^\d+:\d{2}:\d{2}$") {
        timeEdit.Value := A_Clipboard
        CalculateFromPattern()
    }
}

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

; Show the GUI
tCal.Show("Center")