/************************************************************************
* @description Custom Cursor Handler
* @license WTFPL
* @file CursorHandler.ahk
* @author Aaqil Ilyas
* @link ()
* @date 2024-10-19
* @version 1.0.0
* @copyright 2024 Aaqil Ilyas
**************************************************************************/

/*
 * The following code block is from a youtube video (https://www.youtube.com/watch?v=jn83VAU3tBw) but the code in tha video is for autohotkey v1 and I am using v2 in here so, I used AHK-v2-script-converter (https://github.com/mmikeww/AHK-v2-script-converter) by mmikeww
 * and Changed some of the codes myself, now it works :)
*/

/*
! This method will only works for in-build ahk control types
! ; IDC constants for LoadCursor (WinAPI)
! global IDC_APPSTARTING := 32650   ; IDC_APPSTARTING - App Starting
! global IDC_ARROW := 32512         ; IDC_ARROW - Arrow
! global IDC_CROSS := 32515         ; IDC_CROSS - Cross
! global IDC_HAND := 32649          ; IDC_HAND - Hand
! global IDC_HELP := 32651          ; IDC_HELP - Help
! global IDC_IBEAM := 32513         ; IDC_IBEAM - I Beam
! global IDC_NO := 32648            ; IDC_NO - Slashed Circle
! global IDC_SIZEALL := 32646       ; IDC_SIZEALL - Four-pointed star
! global IDC_SIZENESW := 32643      ; IDC_SIZENESW - Double arrow pointing NE and SW
! global IDC_SIZENS := 32645        ; IDC_SIZENS - Double arrow pointing N and S
! global IDC_SIZENWSE := 32642      ; IDC_SIZENWSE - Double arrow pointing NW and SE
! global IDC_SIZEWE := 32644        ; IDC_SIZEWE - Double arrow pointing W and E
! global IDC_UPARROW := 32516       ; IDC_UPARROW - Up arrow
! global IDC_WAIT := 32514          ; IDC_WAIT - Hourglass
! 
! ; Create a map to store cursors
! global Cursors := Map()
! 
! ; Initialize cursor handles
! Cursors["hand"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HAND, "UPtr")
! Cursors["ibeam"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_IBEAM, "UPtr")
! Cursors["cross"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_CROSS, "UPtr")
! Cursors["wait"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_WAIT, "UPtr")
! Cursors["arrow"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_ARROW, "UPtr")
! Cursors["sizens"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZENS, "UPtr")
! Cursors["sizewe"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZEWE, "UPtr")
! Cursors["sizeall"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZEALL, "UPtr")
! Cursors["no"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_NO, "UPtr")
! Cursors["help"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HELP, "UPtr")
! Cursors["uparrow"] := DllCall("LoadCursor", "UInt", 0, "Int", IDC_UPARROW, "UPtr")
! 
! ; Map to store control-cursor associations
! global ControlCursors := Map(
!     "Button", "hand",       ; Buttons
!     "CheckBox", "hand",     ; Check boxes
!     "Pic", "hand",          ; Pic boxes
!     "Text", "hand",         ; Text boxes
!     "Edit", "ibeam",        ; Edit boxes
!     "ComboBox", "hand",     ; Combo boxes
!     "ListBox", "hand",      ; List boxes
!     "ListView", "hand",     ; List views
!     "TreeView", "hand",     ; Tree views
!     "Link", "hand",         ; Links
!     "Slider", "sizewe",     ; Sliders
!     "Progress", "arrow",    ; Progress bars
!     "Tab", "hand",          ; Tabs
!     "UpDown", "hand",       ; Up-down controls
!     "MonthCal", "hand",     ; Month calendar
!     "Hotkey", "ibeam",      ; Hotkey controls
!     "DateTime", "hand",     ; Date/time picker
!     "Custom", "arrow"       ; Custom controls
! )
! 
! ; Function to set cursor for a specific control type
! SetControlCursor(controlType, cursorType) {
!     if !Cursors.Has(cursorType)
!         throw ValueError("Invalid cursor type: " . cursorType)
!     ControlCursors[controlType] := cursorType
! }
! 
! ; Handle mouse movement
! OnMessage(0x200, WM_MOUSEMOVE)
! WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
!     ; Get control under cursor
!     MouseGetPos(,, &hWnd, &controlClassNN)
!     
!     if !controlClassNN
!         return DllCall("SetCursor", "UPtr", Cursors["arrow"])
! 
!     ; Convert hwnd to control handle
!     try {
!         ; Get window style
!         style := DllCall("GetWindowLong", "Ptr", hwnd, "Int", -16, "Int")
! 
!         ; Check if it's our PicSwitch control
!         if (WinExist("ahk_id " hwnd)) {
!             DllCall("SetCursor", "UPtr", Cursors)
!         }
!     }
!     
!     ; Convert to string and get base control type
!     controlClass := String(controlClassNN)
!     baseType := RegExReplace(controlClass, "\d+$", "")  ; Remove trailing numbers
!     
!     ; Get cursor type for this control (default to arrow if not specified)
!     cursorType := ControlCursors.Has(baseType) ? ControlCursors[baseType] : "arrow"
!     
!     ; Set the cursor
!     DllCall("SetCursor", "UPtr", Cursors[cursorType])
! }
*/

; IDC constants for LoadCursor (WinAPI)
global IDC_APPSTARTING := 32650   ; IDC_APPSTARTING - App Starting
global IDC_ARROW := 32512         ; IDC_ARROW - Arrow
global IDC_CROSS := 32515         ; IDC_CROSS - Cross
global IDC_HAND := 32649          ; IDC_HAND - Hand
global IDC_HELP := 32651          ; IDC_HELP - Help
global IDC_IBEAM := 32513         ; IDC_IBEAM - I Beam
global IDC_NO := 32648            ; IDC_NO - Slashed Circle
global IDC_SIZEALL := 32646       ; IDC_SIZEALL - Four-pointed star
global IDC_SIZENESW := 32643      ; IDC_SIZENESW - Double arrow pointing NE and SW
global IDC_SIZENS := 32645        ; IDC_SIZENS - Double arrow pointing N and S
global IDC_SIZENWSE := 32642      ; IDC_SIZENWSE - Double arrow pointing NW and SE
global IDC_SIZEWE := 32644        ; IDC_SIZEWE - Double arrow pointing W and E
global IDC_UPARROW := 32516       ; IDC_UPARROW - Up arrow
global IDC_WAIT := 32514          ; IDC_WAIT - Hourglass

; Load the app starting cursor
global AppstartingCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_APPSTARTING, "UPtr")

; Load the default cursor
global ArrowCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_ARROW, "UPtr")

; Load the cross cursor
global CrossCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_CROSS, "UPtr")

; Load the hand cursor once
global HandCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HAND, "UPtr")

; Load the help cursor
global HelpCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HELP, "UPtr")

; Load the I Beam cursor
global IBeamCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_IBEAM, "UPtr")

; Load the no cursor
global NoCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_NO, "UPtr")

; Load the size all cursor
global SizeAllCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZEALL, "UPtr")

; Load the size NE SW cursor
global SizeNESWCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZENESW, "UPtr")

; Load the size N S cursor
global SizeNSCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZENS, "UPtr")

; Load the size NW SE cursor
global SizeNWSECursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZENWSE, "UPtr")

; Load the size W E cursor
global SizeWECursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_SIZEWE, "UPtr")

; Load the up arrow cursor
global UpArrowCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_UPARROW, "UPtr")

; Load the hourglass cursor
global WaitCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_WAIT, "UPtr")


; Set the cursor when hovering over controls
OnMessage(0x200, WM_MOUSEMOVE)
WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
    ; Get control under cursor
    MouseGetPos(, , &window, &control)

    ; Early exit if no control
    if !control
        return

    ; Convert hwnd to control handle
    try {
        ; Get window style
        style := DllCall("GetWindowLong", "Ptr", hwnd, "Int", -16, "Int")

        ; Check if it's our PicSwitch control
        if (WinExist("ahk_id " hwnd)) {
            DllCall("SetCursor", "UPtr", HandCursor)
        }
        if (control == "Edit1")
            DllCall("SetCursor", "UInt", IBeamCursor)
        if (control == "Button")
            DllCall("SetCursor", "UInt", IBeamCursor)
    }
}