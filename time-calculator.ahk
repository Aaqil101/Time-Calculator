/************************************************************************
 * @description Converts hours, minutes, and seconds into hours.
 * @license GPL-3.0
 * @file time-calculator.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/FF-Creation)
 * @created 2024-10-20
 * @version 1.2.0
 * @copyright 2024 Aaqil Ilyas
 **************************************************************************/


#Requires Autohotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance Force ;Only launch anstance of thi5 scrxpt.
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
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\CursorHandler.ahk

#Requires AutoHotkey v2.0

; Create the main GUI window
tCal := Gui("AlwaysOnTop", "Time to Hours Calculator")

; Create input boxes with better alignment
tCal.Add("Text", "x10 y10", "Hours:")
hoursEdit := tCal.AddEdit("x70 y8 w60 vHours")

tCal.Add("Text", "x140 y10", "Minutes:")
minutesEdit := tCal.AddEdit("x200 y8 w60 vMinutes")

tCal.Add("Text", "x270 y10", "Seconds:")
secondsEdit := tCal.AddEdit("x330 y8 w60 vSeconds")

; Add calculate button
calculateBtn := tCal.AddButton("x10 y40 w100", "Calculate")

; Add result text with better positioning
resultText := tCal.AddText("x120 y43 w200")

; Function to convert time to hours
TimeToHours(hours, minutes, seconds) {
    totalHours := hours + (minutes / 60) + (seconds / 3600)
    return Round(totalHours, 2)  ; Round to 2 decimal places
}

; Button click event handler
calculateBtn.OnEvent("Click", Calculate)

Calculate(*) {
    try {
        ; Get values from input boxes
        hours := Number(hoursEdit.Value)
        minutes := Number(minutesEdit.Value)
        seconds := Number(secondsEdit.Value)
    } catch {
        MsgBox "Please enter Hours, Minutes, and Seconds"
        return
    }
    
    /* ; Validate input
    if (hours = "" || minutes = "" || seconds = "") {
        MsgBox "Please enter valid numbers for all fields"
        return
    } */
    
    ; Calculate total hours
    total := TimeToHours(hours, minutes, seconds)
    
    ; Display result
    resultText.Value := Format("{1} hours", total)
    
    ; Copy result to clipboard
    A_Clipboard := total
    
    ; Show tooltip indicating copy
    ToolTip "Result copied to clipboard!"
    SetTimer () => ToolTip(), -1000  ; Hide tooltip after 1 second
    
    ; Clear input boxes
    hoursEdit.Value := ""
    minutesEdit.Value := ""
    secondsEdit.Value := ""
    
    ; Set focus back to hours input
    hoursEdit.Focus()
}

; Show the GUI
tCal.Show()