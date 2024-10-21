/************************************************************************
 * @description A highly configurable message box library for AutoHotkey v2 that provides
 * extensive customization options for creating modern, stylish dialog boxes. Features
 * include customizable colors, fonts, buttons, positioning, auto-close timers, and
 * multiple pre-defined color schemes with support for custom themes.
 * 
 * @license GPL-3.0
 * @file CustomMsgbox.ahk
 * @author Aaqil Ilyas
 * @link (https://github.com/Aaqil101/Custom-Libraries/tree/master/Custom%20Msgbox)
 * @created 2024-10-17
 * @version 2.1.0
 * @copyright 2024 Aaqil Ilyas
 **************************************************************************/

#Requires Autohotkey v2.0

/*
* Include the GuiEnhancerKit library, which provides a set of functions to enhance the look and feel of AutoHotkey GUIs.
* For more information, see https://github.com/nperovic/GuiEnhancerKit

* Include the ColorButton library, which allows you to create custom buttons.
* For more information, see https://github.com/nperovic/ColorButton.ahk

* Include the ColorSchemes library, which allows you to create custom color schemes.
*/

#Include GuiEnhancerKit.ahk
#Include ColorButton.ahk
#Include ColorSchemes.ahk

class CustomMsgBox {
    ; Add these constants at the top of the CustomMsgBox class
    static GuiOptions := Map(
        "AlwaysOnTop", "+AlwaysOnTop",      ; Makes the window stay on top of other windows
        "Border", "-Border",                 ; Removes the window border
        "Caption", "-Caption",               ; Removes the title bar
        "Disabled", "+Disabled",             ; Creates a disabled window
        "LastFound", "+LastFound",           ; Sets the window as "last found" for commands
        "MaximizeBox", "+MaximizeBox",       ; Adds maximize button
        "MinimizeBox", "+MinimizeBox",       ; Adds minimize button
        "MinSize", "+MinSize",               ; Sets minimum window size
        "MaxSize", "+MaxSize",               ; Sets maximum window size
        "OwnDialogs", "+OwnDialogs",         ; Makes the window own its dialogs
        "Resize", "+Resize",                 ; Makes the window resizable
        "SysMenu", "+SysMenu",               ; Adds system menu
        "Theme", "-Theme",                   ; Disables visual styles
        "ToolWindow", "+ToolWindow",         ; Creates a tool window with smaller title bar
        "Owner", "+Owner"                    ; Sets window ownership
    )

    ; Properties
    title := "Lorem Ipsum"
    owner := ""
    showX := 0
    showY := 0
    bgColor := "313131"
    iconPath := ""
    gui := ""

    ; timer property
    closeTimer := 0

    ; Add these properties to store options
    options := []
    minWidth := 0
    minHeight := 0
    maxWidth := 0
    maxHeight := 0

    ; button properties
    btn1Text := "OK"
    btn1Width := 75
    btn1Height := 25
    btn1PosX := 240
    btn1PosY := 10
    btnCol := "0xaa2031"
    btn1cmbShow := 0
    btn1cmbCol := 0
    btn1cmbRCorner := 9

    ; text properties
    text := "Lorem Ipsum"
    textWidth := 300

    ; font style properties
    isBold := false
    isItalic := false
    isStrike := false
    isUnderline := false
    fontSize := 12
    fontColor := "ffffff"
    fontFamily := "Segoe UI"
    fontWeight := 400        ; Normal=400, Bold=700
    fontQuality := 5         ; 5=ClearType

    ; Constructor
    __New(params*) {
        ; Apply random color scheme on creation
        this.RandomizeColors()

        ; Constructor with optional parameters
        if params.Length >= 1
            this.text := params[1]
        if params.Length >= 2
            this.textWidth := params[2]
        if params.Length >= 3
            this.title := params[3]
        if params.Length >= 4
            this.owner := params[4]
    }

    /**
     * Sets a timer to automatically close the message box
     * @param {Integer} seconds - Number of seconds before the message box closes
     * @returns {CustomMsgBox} This object, for method chaining
     */
    SetCloseTimer(seconds) {
        this.closeTimer := seconds
        return this
    }

    /**
     * Sets the message text to be displayed in the message box.
     * @param {String} text The text to be displayed in the message box.
     * @param {number} [width] The width of the text in pixels. If not specified, the default width of 300 is used.
     * @returns {CustomMsgBox} The current instance of the CustomMsgBox class.
     */
    SetText(title, text, width := "") {
        this.text := text
        this.title := title
        if width
            this.textWidth := width
        return this
    }

    /**
     * Sets the position of the message box window.
     * @param {Number} x The x-coordinate of the window position.
     * @param {Number} y The y-coordinate of the window position.
     * @returns {CustomMsgBox} This object for chaining.
     */
    SetPosition(x, y) {
        /**
         * The x-coordinate of the window position.
         * @type {Number}
         */
        this.showX := x

        /**
         * The y-coordinate of the window position.
         * @type {Number}
         */
        this.showY := y

        return this
    }

    /**
     * Sets the appearance of the message box.
     * @param {number} [fontSize] - The font size to use.
     * @param {String} [fontColor] - The font color to use.
     * @param {String} [bgColor] - The background color to use.
     * @returns {CustomMsgBox} This object, for method chaining.
     */
    ; Method to set appearance
    SetAppearance(fontSize := "", fontColor := "", bgColor := "") {
        if fontSize
            this.fontSize := fontSize
        if fontColor
            this.fontColor := fontColor
        if bgColor
            this.bgColor := bgColor
        return this
    }

    /**
     * Method to set the appearance of the button with optional parameters for customization
     * @param {String} btnColor - The color of the button
     * @param {number} cmbShow - Optional: The color of the button when hovered
     * @param {String} cmbCol - Optional: The color of the button when clicked
     * @param {number} cmbRCorner - Optional: The radius of the button's corners
     * @returns {CustomMsgBox} This object, for method chaining.
     */
    SetButtonStyle(btnColor, cmbShow := "", cmbCol := "", cmbRCorner := "") {
        ; Set the button color
        this.btnCol := btnColor
        ; Set the hover color if specified
        if cmbShow != ""
            this.btn1cmbShow := cmbShow
        ; Set the click color if specified
        if cmbCol != ""
            this.btn1cmbCol := cmbCol
        ; Set the corner radius if specified
        if cmbRCorner != ""
            this.btn1cmbRCorner := cmbRCorner
        return this
    }

    /**
     * Sets the text and width of a button.
     * @param {String} btnText - The text to display on the button.
     * @param {Number} [btnWidth] - Optional: The width of the button.
     * @returns {CustomMsgBox} This object, for method chaining.
     */
    SetButton(btnText, btnWidth := "", btnHeight := "", btnPosX := "", btnPosY := "") {
        ; Set the button text if specified
        if btnText
            this.btn1Text := btnText
        ; Set the button width if specified
        if btnWidth
            this.btn1Width := btnWidth
        ; Set the button height if specified
        if btnHeight
            this.btn1Height := btnHeight
        ; Set the button position if specified
        if btnPosX
            this.btn1PosX := btnPosX
        ; Set the button position if specified
        if btnPosY
            this.btn1PosY := btnPosY
        return this
    }

    /**
     * Method to set font styles
     * @param {Array} options - List of font style options
     * @example
     * SetFontStyle(["bold", "italic"])
     * @returns {CustomMsgBox} - This object for method chaining
     */
    SetFontStyle(options*) {
        /**
         * Loop through the options and set the corresponding font style
         * @param {String} option - Font style option
         */
        for option in options {
            /**
             * Switch through the options and set the corresponding font style
             * @param {String} option - Font style option
             */
            switch option {
                /**
                 * Set the font to bold
                 */
                case "bold", "Bold":
                    this.isBold := true
                    this.fontWeight := 700
                    /*
                    ! Depracated method, do not use
                    !case "normal", "Normal":
                        !this.isBold := false
                        !this.fontWeight := 400
                    */
                    /**
                     * Set the font to italic
                     */
                case "italic", "Italic":
                    this.isItalic := true
                    /**
                     * Set the font to strike-through
                     */
                case "strike", "Strike":
                    this.isStrike := true
                    /**
                     * Set the font to underline
                     */
                case "underline", "Underline":
                    this.isUnderline := true
            }
        }
        return this
    }

    /**
     * Method to clear font styles
     * @param {String|Array<String>} options - Options to clear font style. Can be "bold", "italic", "strike", "underline", "all"
     * @returns {CustomMsgBox} - This object
     */
    ClearFontStyle(options*) {
        /**
         * Loop through the options and clear the corresponding font style
         */
        for option in options {
            switch option {
                case "bold", "Bold":
                    /**
                     * Clear bold font style
                     */
                    this.isBold := false
                case "italic", "Italic":
                    /**
                     * Clear italic font style
                     */
                    this.isItalic := false
                case "strike", "Strike":
                    /**
                     * Clear strike font style
                     */
                    this.isStrike := false
                case "underline", "Underline":
                    /**
                     * Clear underline font style
                     */
                    this.isUnderline := false
                case "all", "All":
                    /**
                     * Clear all font styles
                     */
                    this.isBold := false
                    this.isItalic := false
                    this.isStrike := false
                    this.isUnderline := false
            }
        }
        return this
    }

    /**
     * Sets the font family of the message box.
     * @param {String} fontName The name of the font family to use.
     * @returns {CustomMsgBox} This object, for method chaining.
     */
    SetFontFamily(fontName) {
        /**
         * The name of the font family to use.
         * @type {String}
         */
        this.fontFamily := fontName

        return this
    }

    /**
     * Method to set font color
     * @param {String} fontColor - The new font color in hex format (e.g. "#FFFFFF" or "0xFFFFFF")
     * @returns {CustomMsgBox} This object, for method chaining.
     */
    SetFontColor(fontColor) {
        /** @type {String} */
        this.fontColor := fontColor
        return this
    }

    /**
     * Builds the font options string for the AddText method
     * @returns {String} The font options string
     */
    BuildFontOptions() {
        options := "s" this.fontSize    ; Size

        ; Add styles
        if this.isBold
            options .= " Bold"
        if this.isItalic
            options .= " Italic"
        if this.isStrike
            options .= " Strike"
        if this.isUnderline
            options .= " Underline"

        ; Add color and quality
        options .= " c" this.fontColor
        options .= " q" this.fontQuality

        return options
    }

    /**
     * Randomly selects and applies a color scheme from the ColorSchemes library.
     * @returns {ColorButton} The ColorButton instance with the new color scheme applied.
     */
    RandomizeColors() {
        ; Get random index
        random_index := Random(1, ColorSchemes.Schemes.Length)

        ; Apply the selected color scheme
        scheme := ColorSchemes.Schemes[random_index]
        this.bgColor := scheme.bg
        this.fontColor := scheme.font
        this.btnCol := "0x" scheme.btn

        return this
    }

    /**
     * Method to apply a specific color scheme by index
     * @param {Integer|String} indexOrName - The index of the color scheme to apply, or the name of the color scheme
     * @returns {this} - The current ColorButton object, for chaining
     */
    SetColorScheme(indexOrName) {
        if IsNumber(indexOrName) {
            if (indexOrName > 0 && indexOrName <= ColorSchemes.Schemes.Length) {
                scheme := ColorSchemes.Schemes[indexOrName]
            }
        } else {
            scheme := ColorSchemes.GetSchemeByName(indexOrName)
        }

        if (scheme) {
            this.bgColor := scheme.bg
            this.fontColor := scheme.font
            this.btnCol := "0x" scheme.btn
        }
        return this
    }

    /**
     * Sets GUI window options
     * @param {Array} optionsList Array of option names to enable
     * @returns {CustomMsgBox} This object for method chaining
     */
    SetOptions(optionsList*) {
        for option in optionsList {
            if CustomMsgBox.GuiOptions.Has(option)
                this.options.Push(CustomMsgBox.GuiOptions[option])
        }
        return this
    }

    /**
     * Sets minimum window size
     * @param {Integer} width Minimum width in pixels
     * @param {Integer} height Minimum height in pixels
     * @returns {CustomMsgBox} This object for method chaining
     */
    SetMinSize(width, height) {
        this.minWidth := width
        this.minHeight := height
        this.options.Push("+MinSize" . width . "x" . height)
        return this
    }

    /**
     * Sets maximum window size
     * @param {Integer} width Maximum width in pixels
     * @param {Integer} height Maximum height in pixels
     * @returns {CustomMsgBox} This object for method chaining
     */
    SetMaxSize(width, height) {
        this.maxWidth := width
        this.maxHeight := height
        this.options.Push("+MaxSize" . width . "x" . height)
        return this
    }

    /**
     * Adds a new color scheme to the collection of available schemes.
     * @param {string} bgColor - The background color of the scheme in hexadecimal format (e.g. "#331111").
     * @param {string} fontColor - The font color of the scheme in hexadecimal format (e.g. "#ffffff").
     * @param {string} btnColor - The button color of the scheme in hexadecimal format (e.g. "#aa2031").
     */
    static AddColorScheme(nameColor, bgColor, fontColor, btnColor) {
        ; Add the new scheme to the collection of available schemes
        ColorSchemes.Schemes.Push({
            name: nameColor,
            bg: bgColor,
            font: fontColor,
            btn: btnColor
        })
    }

    /**
     * Method to get available color schemes
     * @example ; Get list of available scheme names 
     * schemes := CustomMsgBox.GetAvailableSchemes()
     * for schemeName in schemes {
     *     MsgBox(schemeName)
     * }
     * @return {Array} An array of strings containing the names of all available color schemes
     */
    static GetAvailableSchemes() {
        return ColorSchemes.GetSchemeNames()
    }

    /**
     * Method to preview all color schemes
     * @example ; Preview all available schemes
     * msg := CustomMsgBox()
     * msg.PreviewSchemes()
     * @returns {void}
     */
    PreviewSchemes() {
        ; Loop through all color schemes and preview them
        for scheme in ColorSchemes.Schemes {
            msg := CustomMsgBox("Preview of " scheme.name " theme")
            msg.SetColorScheme(scheme.name)
            msg.SetPosition(this.showX, this.showY)
            .Show()
        }
    }

    /**
     * Creates and shows the message box.
     * @returns {CustomMsgBox} This object, for method chaining.
     */
    Show() {
        ; Combine all options into a single string
        optString := ""
        for opt in this.options
            optString .= " " opt

        ; Create GUI with combined options
        this.gui := GuiExt(optString)

        ; Set font with all specified styles
        this.gui.SetFont(this.BuildFontOptions(), this.fontFamily)

        this.gui.SetDarkTitle()
        this.gui.SetDarkMenu()
        this.gui.BackColor := this.bgColor
        this.gui.Title := this.title

        ; Add text
        this.AddMessageText()

        ; Add OK button
        this.AddButton1()

        ; Set up timer if specified
        if (this.closeTimer > 0) {
            ; Convert seconds to milliseconds
            timeout := this.closeTimer * 1000
            SetTimer(() => this.gui.Destroy(), -timeout)  ; Negative timeout means run once
        }

        ; Show the GUI
        this.gui.Show("x" this.showX " y" this.showY "AutoSize")

        ; Make the GUI modal
        this.gui.Opt("+OwnDialogs")
        WinWaitClose(this.gui)
    }

    /**
     * Private method to add message text
     * @returns {void} Nothing
     */
    AddMessageText() {
        this.gui.AddText("w" this.textWidth, this.text)
    }

    ; Private method to add OK button
    ; Adds a button to the GUI with specified properties and behavior.
    ; The button will destroy the GUI when clicked.
    AddButton1() {
        btn := this.gui.AddButton("w" this.btn1Width " h" this.btn1Height " x" this.btn1PosX " y+" this.btn1PosY, this.btn1Text)
        btn.SetColor(this.btnCol, this.fontColor, this.btn1cmbShow, this.btn1cmbCol, this.btn1cmbRCorner) ; Set button colors
        btn.OnEvent("Click", (*) => this.gui.Destroy()) ; Set event handler for button click to destroy the GUI
    }
}

/*
! Depracated method, do not use
!CustomMsgBox(
!    Text := "test",
!    TextWidth := 300,
!    Title := "test",
!    Owner := "",
!    ShowX := 0,
!    ShowY := 0,
!    FontSize := 12,
!    FontColor := "ffffff",
!    BgColor := "313131",
!    CmbShow := 0,
!    CmbCol := 0,
!    CmbRCorner := 9,
!    BtnCol := "0xaa2031"
!) {
!    ; Create a new GUI
!    CMsgboxGui := GuiExt("+AlwaysOnTop")
!    CMsgboxGui.Opt("+Owner" . Owner)  ; If no owner, it will be unowned
!    CMsgboxGui.SetFont("s" FontSize " Bold c" FontColor, "JetBrains Mono")
!    CMsgboxGui.SetDarkTitle()
!    CMsgboxGui.SetDarkMenu()
!    CMsgboxGui.BackColor := BgColor
!    CMsgboxGui.Title := Title
!
!    CMsgboxGui.AddText("w" TextWidth, Text)
!
!    ; Add an OK button
!    custommsgbox_btn1 := CMsgboxGui.AddButton("w75 x240 y+10", "OK")
!    custommsgbox_btn1.SetColor(BtnCol, FontColor, CmbShow, CmbCol, CmbRCorner)
!    custommsgbox_btn1.OnEvent("Click", (*) => CMsgboxGui.Destroy())
!
!    ; Show the GUI at a specific position
!    CMsgboxGui.Show("x" ShowX " y" ShowY " AutoSize")  ; Adjust x and y as needed
!
!    ; Make the GUI modal
!    CMsgboxGui.Opt("+OwnDialogs")
!    WinWaitClose(CMsgboxGui)
!}
*/
