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

* Include the CustomMsgbox library, which allows you to create custom message boxes.
* For more information, see https://github.com/Aaqil101/Custom-Libraries/tree/master/Custom%20Msgbox
*/

#Include Lib\GuiEnhancerKit.ahk
#Include Lib\ColorButton.ahk
#Include Lib\CursorHandler.ahk
#Include Lib\CustomMsgbox.ahk

; Modern GUI Styles Library
class ModernStyles {
    static BackColor := "0xFFFFFF"  ; White background
    static TextColor := "0x000000"  ; Black text
    static AccentColor := "0x4CAF50"  ; Material Green
    static Gray := "0xE0E0E0"  ; Light gray for borders
    
    static Init() {
        ; Set custom window styles
        DllCall("UxTheme\SetWindowTheme", "Ptr", MyGui.Hwnd, "Str", "Explorer", "Ptr", 0)
    }
    
    static StyleEdit(ctl, options := "") {
        ; Modern edit control style
        ctl.Opt("+Background" this.BackColor)
        DllCall("UxTheme\SetWindowTheme", "Ptr", ctl.Hwnd, "Str", "Explorer", "Ptr", 0)
        
        ; Add border
        ctl.OnEvent("Focus", this.EditFocus)
        ctl.OnEvent("LoseFocus", this.EditLoseFocus)
        
        ; Set font
        ctl.SetFont("s10", "Segoe UI")
    }
    
    static StyleButton(ctl) {
        ; Modern button style
        ctl.SetFont("s10", "Segoe UI")
        ctl.OnEvent("Focus", this.ButtonFocus)
        ctl.OnEvent("LoseFocus", this.ButtonLoseFocus)
    }
    
    static EditFocus(ctl, *) {
        ctl.Opt("+Border")
        SetTimer () => this.DrawBorder(ctl.Hwnd, this.AccentColor), -1
    }
    
    static EditLoseFocus(ctl, *) {
        ctl.Opt("+Border")
        SetTimer () => this.DrawBorder(ctl.Hwnd, this.Gray), -1
    }
    
    static ButtonFocus(ctl, *) {
        ctl.Opt("+Border")
        SetTimer () => this.DrawBorder(ctl.Hwnd, this.AccentColor), -1
    }
    
    static ButtonLoseFocus(ctl, *) {
        ctl.Opt("+Border")
        SetTimer () => this.DrawBorder(ctl.Hwnd, this.Gray), -1
    }
    
    static DrawBorder(hwnd, color) {
        ; Draw custom border
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

; Create the main GUI window
MyGui := Gui("-Caption +Border")
ModernStyles.Init()

; Add title bar
MyGui.SetFont("s12 Bold", "Segoe UI")
MyGui.Add("Text", "x10 y10 w400 h30", "Time to Hours Calculator")

; Create input boxes with modern styling
MyGui.SetFont("s10", "Segoe UI")  ; Reset font for rest of controls

MyGui.Add("Text", "x10 y50", "Hours:")
hoursEdit := MyGui.Add("Edit", "x70 y48 w60 h25 vHours")
ModernStyles.StyleEdit(hoursEdit)

MyGui.Add("Text", "x140 y50", "Minutes:")
minutesEdit := MyGui.Add("Edit", "x200 y48 w60 h25 vMinutes")
ModernStyles.StyleEdit(minutesEdit)

MyGui.Add("Text", "x270 y50", "Seconds:")
secondsEdit := MyGui.Add("Edit", "x330 y48 w60 h25 vSeconds")
ModernStyles.StyleEdit(secondsEdit)

; Add calculate button with modern styling
calculateBtn := MyGui.Add("Button", "x10 y90 w100 h30", "Calculate")
ModernStyles.StyleButton(calculateBtn)

; Add result text
MyGui.SetFont("s10")
resultText := MyGui.Add("Text", "x120 y95 w200 h25")

; Add a close button in the top right
closeBtn := MyGui.Add("Button", "x380 y10 w30 h20", "×")
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
MyGui.Show("w420 h130")
