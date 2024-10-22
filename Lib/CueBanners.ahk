/************************************************************************
 * @description Sets placeholder text for Edit and ComboBox controls
 * @license WTFPL
 * @file CueBanners.ahk
 * @author jNizM modified by Aaqil Ilyas
 * @link (https://github.com/Aaqil101/Time-Calculator)
 * @created 2024-10-22
 * @version 2.0.1
 **************************************************************************/

/*
* All credits go to the original author. (https://github.com/jNizM).
* I just converted the AutoHotkey v1 to AutoHotkey v2 and changed from function to class. I also added some comments.
* Converted using (https://claude.ai).
* Take a look at the original script in (https://github.com/jNizM/AHK_Scripts/blob/master/src/gui/GUI_Cue_Banner.ahk).
*/

#Requires Autohotkey v2.0

/*
! Deprecated method, do not use.
class CueBanners {
    ; Windows Messages for setting cue banners
    static EM_SETCUEBANNER := 0x1501
    static CB_SETCUEBANNER := 0x1703
    
    /**
     * Sets a placeholder text for an Edit control
     * @param ctrl {Gui.Edit|Integer} The Edit control object or handle
     * @param text {String} The placeholder text to display
     * @param stayOnFocus {Boolean} If true, placeholder stays visible when control has focus
     * @returns {Integer} Nonzero if successful, zero if unsuccessful
    
    static SetEdit(ctrl, text, stayOnFocus := false) {
        if !IsSet(ctrl) || !IsSet(text)
            return 0
            
        try {
            handle := IsInteger(ctrl) ? ctrl : ctrl.Hwnd
            return DllCall("user32\SendMessage",
                "Ptr", handle,
                "UInt", this.EM_SETCUEBANNER,
                "Int", stayOnFocus,
                "Str", text,
                "Int")
        }
        return 0
    }
    
    /**
     * Sets a placeholder text for a ComboBox control
     * @param ctrl {Gui.ComboBox|Integer} The ComboBox control object or handle
     * @param text {String} The placeholder text to display
     * @returns {Integer} Nonzero if successful, zero if unsuccessful
    
    static SetComboBox(ctrl, text) {
        if !IsSet(ctrl) || !IsSet(text)
            return 0
            
        try {
            handle := IsInteger(ctrl) ? ctrl : ctrl.Hwnd
            return DllCall("user32\SendMessage",
                "Ptr", handle,
                "UInt", this.CB_SETCUEBANNER,
                "Int", 0,
                "Str", text,
                "Int")
        }
        return 0
    }
}
! */

class CueBanners {
    ; Windows Messages for setting cue banners
    static EM_SETCUEBANNER := 0x1501
    static CB_SETCUEBANNER := 0x1703
    
    /**
     * Sets a placeholder text for an Edit control
     * @param ctrl {Gui.Edit|Integer} The Edit control object or handle
     * @param text {String} The placeholder text to display
     * @param stayOnFocus {Boolean} If true, placeholder stays visible when control has focus
     * @returns {Integer} Nonzero if successful, zero if unsuccessful
     */
    static SetEdit(ctrl, text, stayOnFocus := false) {
        if !IsSet(ctrl) || !IsSet(text)
            return 0
            
        try {
            handle := IsInteger(ctrl) ? ctrl : ctrl.Hwnd
            return DllCall("user32\SendMessage",
                "Ptr", handle,
                "UInt", this.EM_SETCUEBANNER,
                "Int", stayOnFocus,
                "Str", text,
                "Int")
        }
        return 0
    }
    
    /**
     * Sets a placeholder text for a ComboBox control
     * @param ctrl {Gui.ComboBox|Integer} The ComboBox control object or handle
     * @param text {String} The placeholder text to display
     * @param stayOnFocus {Boolean} If true, placeholder stays visible when control has focus
     * @returns {Integer} Nonzero if successful, zero if unsuccessful
     */
    static SetComboBox(ctrl, text, stayOnFocus := false) {
        if !IsSet(ctrl) || !IsSet(text)
            return 0
            
        try {
            handle := IsInteger(ctrl) ? ctrl : ctrl.Hwnd
            return DllCall("user32\SendMessage",
                "Ptr", handle,
                "UInt", this.CB_SETCUEBANNER,
                "Int", stayOnFocus,
                "Str", text,
                "Int")
        }
        return 0
    }
    
    /**
     * Sets a placeholder text for any supported control (Edit or ComboBox)
     * @param ctrl {Gui.Edit|Gui.ComboBox|Integer} The control object or handle
     * @param text {String} The placeholder text to display
     * @param stayOnFocus {Boolean} If true, placeholder stays visible when control has focus
     * @returns {Integer} Nonzero if successful, zero if unsuccessful
     */
    static Set(ctrl, text, stayOnFocus := false) {
        if !IsSet(ctrl) || !IsSet(text)
            return 0
            
        try {
            if ctrl is Gui.Edit
                return this.SetEdit(ctrl, text, stayOnFocus)
            else if ctrl is Gui.ComboBox
                return this.SetComboBox(ctrl, text, stayOnFocus)
            else if IsInteger(ctrl)
                return this.SetEdit(ctrl, text, stayOnFocus)  ; Best guess if handle provided
        }
        return 0
    }
}

/* 
; * Example:

; Create a new GUI window with "AlwaysOnTop" style
myGui := Gui("AlwaysOnTop")

; Add a button with a caption of "Exit"
myGui.OnEvent("Close", (*) => ExitApp())

; Add an Edit control with a width of 200 pixels
edit1 := myGui.Add("Edit", "w200")
; Set normal cue banners for the Edit control
CueBanners.SetEdit(edit1, "Edit with normal cue banners...")

; Add another Edit control with a width of 200 pixels
edit2 := myGui.Add("Edit", "w200")
; Set focus cue banners for the Edit control
CueBanners.SetEdit(edit2, "Edit with focus cue banners...", true)

; Add a ComboBox control with a width of 200 pixels
combo1 := myGui.Add("ComboBox", "w200")
; Set normal cue banners for the ComboBox control
CueBanners.SetComboBox(combo1, "ComboBox with normal cue banners...")

; Using generic Set method:
CueBanners.Set(anyCtrl, "Enter value...", true)    ; Works with either type

; Show the GUI window
myGui.Show()
 */