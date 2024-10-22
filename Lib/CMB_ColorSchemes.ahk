class ColorSchemes {
    ;There are 21 themes in this file.
    static Schemes := [
        {
            name: "Error",
            bg: "FF0000",
            font: "FFFFFF",
            btn: "d46666"
        },
        {
            name: "Success",
            bg: "E8F5E9",
            font: "1B5E20",
            btn: "4CAF50"
        },
        {   ; Red theme
            name: "Red",
            bg: "331111",
            font: "ffffff",
            btn: "aa2031"
        },
        {   ; Deep Red
            name: "Deep Red",
            bg: "2B0000",
            font: "ffffff",
            btn: "800000"
        },
        {   ; Blue theme
            name: "Blue",
            bg: "111133",
            font: "ffffff",
            btn: "2031aa"
        },
        {   ; Navy Blue
            name: "Navy",
            bg: "000028",
            font: "ffffff",
            btn: "000080"
        },
        {   ; Green theme
            name: "Green",
            bg: "113311",
            font: "ffffff",
            btn: "20aa31"
        },
        {   ; Forest Green
            name: "Forest",
            bg: "002800",
            font: "ffffff",
            btn: "006400"
        },
        {   ; Purple theme
            name: "Purple",
            bg: "331133",
            font: "ffffff",
            btn: "aa31aa"
        },
        {   ; Deep Purple
            name: "Deep Purple",
            bg: "280028",
            font: "ffffff",
            btn: "800080"
        },
        {   ; Orange theme
            name: "Orange",
            bg: "332211",
            font: "ffffff",
            btn: "aa5531"
        },
        {   ; Deep Orange
            name: "Deep Orange",
            bg: "2B1100",
            font: "ffffff",
            btn: "802200"
        },
        {   ; Cyan theme
            name: "Cyan",
            bg: "113333",
            font: "ffffff",
            btn: "31aaaa"
        },
        {   ; Teal
            name: "Teal",
            bg: "002828",
            font: "ffffff",
            btn: "008080"
        },
        {   ; Dark theme
            name: "Dark",
            bg: "222222",
            font: "ffffff",
            btn: "444444"
        },
        {   ; Darker theme
            name: "Darker",
            bg: "111111",
            font: "ffffff",
            btn: "333333"
        },
        {   ; Brown theme
            name: "Brown",
            bg: "2B1600",
            font: "ffffff",
            btn: "8B4513"
        },
        {   ; Gold theme
            name: "Gold",
            bg: "2B2100",
            font: "ffffff",
            btn: "DAA520"
        },
        {   ; Pink theme
            name: "Pink",
            bg: "331122",
            font: "ffffff",
            btn: "FF69B4"
        },
        {   ; Magenta theme
            name: "Magenta",
            bg: "2B0022",
            font: "ffffff",
            btn: "FF00FF"
        },
        {   ; Nord Dark
            name: "Nord Dark",
            bg: "2E3440",
            font: "ffffff",
            btn: "5E81AC"
        },
        {   ; Dracula
            name: "Dracula",
            bg: "282A36",
            font: "ffffff",
            btn: "BD93F9"
        },
        {   ; Monokai Pro
            name: "Monokai Pro",
            bg: "2D2A2E",
            font: "ffffff",
            btn: "FFD866"
        },
        {   ; Tokyo Night
            name: "Tokyo Night",
            bg: "1A1B26",
            font: "ffffff",
            btn: "7AA2F7"
        },
        {   ; Catppuccin Mocha
            name: "Catppuccin",
            bg: "1E1E2E",
            font: "ffffff",
            btn: "89B4FA"
        },
        {   ; Synthwave
            name: "Synthwave",
            bg: "2B213A",
            font: "ffffff",
            btn: "00FF9F"
        },
        {   ; One Dark Pro
            name: "One Dark",
            bg: "282C34",
            font: "ffffff",
            btn: "98C379"
        },
        {   ; GitHub Dark
            name: "GitHub Dark",
            bg: "0D1117",
            font: "ffffff",
            btn: "58A6FF"
        },
        {   ; Gruvbox Dark
            name: "Gruvbox",
            bg: "282828",
            font: "ffffff",
            btn: "B8BB26"
        },
        {   ; Material Ocean
            name: "Ocean",
            bg: "0F111A",
            font: "ffffff",
            btn: "84FFFF"
        },
        {   ; Palenight
            name: "Palenight",
            bg: "292D3E",
            font: "ffffff",
            btn: "82AAFF"
        },
        {   ; Rose Pine
            name: "Rose Pine",
            bg: "191724",
            font: "ffffff",
            btn: "EBBCBA"
        },
        {   ; Ayu Dark
            name: "Ayu",
            bg: "0A0E14",
            font: "ffffff",
            btn: "FFB454"
        },
        {   ; Eva Dark
            name: "Eva Dark",
            bg: "2A3B4D",
            font: "ffffff",
            btn: "FF61C6"
        },
        {   ; Outrun Dark
            name: "Outrun",
            bg: "00002A",
            font: "ffffff",
            btn: "00FFFF"
        },
        {   ; Carbon
            name: "Carbon",
            bg: "161616",
            font: "ffffff",
            btn: "78A9FF"
        },
        {   ; Moonlight
            name: "Moonlight",
            bg: "1E2030",
            font: "ffffff",
            btn: "82AAFF"
        },
        {   ; Horizon
            name: "Horizon",
            bg: "1C1E26",
            font: "ffffff",
            btn: "E95678"
        },
        {   ; Night Owl
            name: "Night Owl",
            bg: "011627",
            font: "ffffff",
            btn: "7FDBCA"
        },
        {   ; Material Deep Ocean
            name: "Deep Ocean",
            bg: "0F111A",
            font: "ffffff",
            btn: "84FFFF"
        }
    ]

    ; Method to get scheme by name
    static GetSchemeByName(name) {
        for scheme in this.Schemes {
            if (scheme.name = name)
                return scheme
        }
        return this.Schemes[1]  ; Return first scheme if not found
    }

    ; Method to get scheme names
    static GetSchemeNames() {
        names := []
        for scheme in this.Schemes
            names.Push(scheme.name)
        return names
    }
}
