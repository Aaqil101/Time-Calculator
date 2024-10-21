class ColorSchemes {
    static Schemes := [
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
            font: "ECEFF4",
            btn: "5E81AC"
        },
        {   ; Dracula
            name: "Dracula",
            bg: "282A36",
            font: "F8F8F2",
            btn: "BD93F9"
        },
        {   ; Monokai Pro
            name: "Monokai Pro",
            bg: "2D2A2E",
            font: "FCFCFA",
            btn: "FFD866"
        },
        {   ; Tokyo Night
            name: "Tokyo Night",
            bg: "1A1B26",
            font: "A9B1D6",
            btn: "7AA2F7"
        },
        {   ; Cyberpunk
            name: "Cyberpunk",
            bg: "2B213A",
            font: "FF0055",
            btn: "00FF9F"
        },
        {   ; Catppuccin Mocha
            name: "Catppuccin",
            bg: "1E1E2E",
            font: "CDD6F4",
            btn: "89B4FA"
        },
        {   ; Synthwave
            name: "Synthwave",
            bg: "2B213A",
            font: "FF7EDB",
            btn: "00FF9F"
        },
        {   ; One Dark Pro
            name: "One Dark",
            bg: "282C34",
            font: "ABB2BF",
            btn: "98C379"
        },
        {   ; GitHub Dark
            name: "GitHub Dark",
            bg: "0D1117",
            font: "C9D1D9",
            btn: "58A6FF"
        },
        {   ; Gruvbox Dark
            name: "Gruvbox",
            bg: "282828",
            font: "EBDBB2",
            btn: "B8BB26"
        },
        {   ; Material Ocean
            name: "Ocean",
            bg: "0F111A",
            font: "8F93A2",
            btn: "84FFFF"
        },
        {   ; Palenight
            name: "Palenight",
            bg: "292D3E",
            font: "BFC7D5",
            btn: "82AAFF"
        },
        {   ; Rose Pine
            name: "Rose Pine",
            bg: "191724",
            font: "E0DEF4",
            btn: "EBBCBA"
        },
        {   ; Ayu Dark
            name: "Ayu",
            bg: "0A0E14",
            font: "B3B1AD",
            btn: "FFB454"
        },
        {   ; Eva Dark
            name: "Eva Dark",
            bg: "2A3B4D",
            font: "7FD1FF",
            btn: "FF61C6"
        },
        {   ; Outrun Dark
            name: "Outrun",
            bg: "00002A",
            font: "FF00FF",
            btn: "00FFFF"
        },
        {   ; Carbon
            name: "Carbon",
            bg: "161616",
            font: "F4F4F4",
            btn: "78A9FF"
        },
        {   ; Moonlight
            name: "Moonlight",
            bg: "1E2030",
            font: "C8D3F5",
            btn: "82AAFF"
        },
        {   ; Horizon
            name: "Horizon",
            bg: "1C1E26",
            font: "E0E0E0",
            btn: "E95678"
        },
        {   ; Night Owl
            name: "Night Owl",
            bg: "011627",
            font: "D6DEEB",
            btn: "7FDBCA"
        },
        {   ; Material Deep Ocean
            name: "Deep Ocean",
            bg: "0F111A",
            font: "A6ACCD",
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
