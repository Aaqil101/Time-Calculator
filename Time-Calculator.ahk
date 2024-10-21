/************************************************************************
 * @description Converts hours, minutes, and seconds into hours.
 * @license GPL-3.0
 * @file time-calculator.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/Time-Calculator)
 * @created 2024-10-21
 * @version 1.4.0
 * @copyright 2024 Aaqil Ilyas
 **************************************************************************/

/*
* I created most of the script using (https://claude.ai) and I modified it.
*/

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

* Include the ColorSchemes library, which allows you to create custom color schemes.
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\CursorHandler.ahk
#Include Lib\CustomMsgbox.ahk
#Include Lib\ToolTipEx.ahk
#Include Lib\ColorSchemes.ahk

; Variables (keeping original variables)
ERRORTIMER := 1.25
EDIT_Y_AXIS := 110
TEXT_Y_AXIS := EDIT_Y_AXIS + 3
BTN_Y := EDIT_Y_AXIS + 33
PATTERN_TEXT_Y := 40
SHOW_WIDTH := 410
SHOW_HEIGHT := 200
fadeSteps := 10
fadeInterval := 100
currentOpacity := 255
FF_ERROR := A_ScriptDir "\Lib\Icons\FF_Error.png"
FF_STOP := A_ScriptDir "\Lib\Icons\FF_Stop.png"
FF_INFO := A_ScriptDir "\Lib\Icons\FF_Info.png"
FF_QUESTION := A_ScriptDir "\Lib\Icons\FF_Question.png"
TIME_CALCULATOR := A_ScriptDir "\Lib\Icons\TC_Icon.png"

; Set Tray icon
TraySetIcon(TIME_CALCULATOR)

; Create the main GUI window
tCal := GuiExt("AlwaysOnTop -Caption +Border")

; Add title bar
tCal.SetFont("s12 Bold cwhite", "Segoe UI")
tCal.AddText("x10 y10 h30", "Time to Hours Calculator")

tCal.SetDarkTitle()
tCal.SetDarkMenu()

; Store text controls for color updates
textControls := []

; Select random scheme at startup
randomScheme := ColorSchemes.Schemes[Random(1, ColorSchemes.Schemes.Length)]
; Msgbox(randomScheme.name, "Random Color Scheme")

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
    closeBtn.SetColor("aa2031", fontColor, 0, 0, 9)
    
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
patternText := tCal.AddText("x10 y" PATTERN_TEXT_Y, "Enter time in format HH:MM:SS (e.g., 34:03:11)")
timeEdit := tCal.AddEdit("x10 y" PATTERN_TEXT_Y + 20 " w390 c313131", "")

; Individual fields section
separateText := tCal.AddText("x10 y" (TEXT_Y_AXIS - 25), "Enter values separately")

tCal.Add("Text", "x10 y" TEXT_Y_AXIS, "Hours:")
hoursEdit := tCal.AddEdit("Limit2 Number x60 y" EDIT_Y_AXIS " w60 vHours c313131")

tCal.Add("Text", "x" 10 + 120 " y" TEXT_Y_AXIS, "Minutes:")
minutesEdit := tCal.AddEdit("Limit2 Number x" 60 + 140 " y" EDIT_Y_AXIS " w60 vMinutes c313131")

tCal.Add("Text", "x" 10 + 120 + 140 " y" TEXT_Y_AXIS, "Seconds:")
secondsEdit := tCal.AddEdit("Limit2 Number x" 60 + 140 + 140 " y" EDIT_Y_AXIS " w60 vSeconds c313131")

; Add calculate buttons
calculatePatternBtn := tCal.AddButton("x10 y" BTN_Y " w140", "Calculate from Pattern")
calculateFieldsBtn := tCal.AddButton("x160 y" BTN_Y " w140", "Calculate from Fields")
closeBtn := tCal.AddButton("x" 10 + 360 " y" 8 " w30", "✖")
closeBtn.OnEvent("Click", (*) => ExitApp())


; Result display
tCal.SetFont("s10 Bold c48ff00", "JetBrains Mono")
resultText := tCal.AddText("x310 y" BTN_Y + 15 " w80")

; Make window draggable
OnMessage(0x201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    static HTCAPTION := 2
    if (hwnd = tCal.Hwnd)
        PostMessage(0xA1, HTCAPTION)
}

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
    msg.SetCloseTimer(ERRORTIMER)
    TraySetIcon(TIME_CALCULATOR)
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
tCal.Show("w" SHOW_WIDTH " h" SHOW_HEIGHT " Center")

; Calculate the "center" position
; Move the mouse to the "center" of the wcGui window
MouseMove(
    SHOW_WIDTH / 2,
    SHOW_HEIGHT / 2
)