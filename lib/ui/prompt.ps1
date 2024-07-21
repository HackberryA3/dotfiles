function Normal {
    process {
		[Console]::ResetColor()
    }
}

# カラー設定用関数
function Set-ForegroundColor {
    param(
        [string]$Color
    )
    process {
		[Console]::ForegroundColor = [System.ConsoleColor]::$color
    }
}
function Fblack {
	process {
		Set-ForegroundColor -Color Black
	}
}
function FWhite {
	process {
		Set-ForegroundColor -Color White
	}
}
function Fdarkgray {
	process {
		Set-ForegroundColor -Color DarkGray
	}
}
function Fgray {
	process {
		Set-ForegroundColor -Color Gray
	}
}
function Fdarkred {
	process {
		Set-ForegroundColor -Color DarkRed
	}
}
function Fred {
	process {
		Set-ForegroundColor -Color Red
	}
}
function Fdarkgreen {
	process {
		Set-ForegroundColor -Color DarkGreen
	}
}
function Fgreen {
	process {
		Set-ForegroundColor -Color Green
	}
}
function Fdarkyellow {
	process {
		Set-ForegroundColor -Color DarkYellow
	}
}
function Fyellow {
	process {
		Set-ForegroundColor -Color Yellow
	}
}
function Fdarkblue {
	process {
		Set-ForegroundColor -Color DarkBlue
	}
}
function Fblue {
	process {
		Set-ForegroundColor -Color Blue
	}
}
function Fdarkmagenta {
	process {
		Set-ForegroundColor -Color DarkMagenta
	}
}
function Fmagenta {
	process {
		Set-ForegroundColor -Color Magenta
	}
}
function Fdarkcyan {
	process {
		Set-ForegroundColor -Color DarkCyan
	}
}
function Fcyan {
	process {
		Set-ForegroundColor -Color Cyan
	}
}

function Set-BackgroundColor {
    param(
        [string]$Color
    )
    process {
        [Console]::BackgroundColor = [System.ConsoleColor]::$color
    }
}
function Bblack {
	process {
		Set-BackgroundColor -Color Black
	}
}
function BWhite {
	process {
		Set-BackgroundColor -Color White
	}
}
function Bdarkgray {
	process {
		Set-BackgroundColor -Color DarkGray
	}
}
function Bgray {
	process {
		Set-BackgroundColor -Color Gray
	}
}
function Bdarkred {
	process {
		Set-BackgroundColor -Color DarkRed
	}
}
function Bred {
	process {
		Set-BackgroundColor -Color Red
	}
}
function Bdarkgreen {
	process {
		Set-BackgroundColor -Color DarkGreen
	}
}
function Bgreen {
	process {
		Set-BackgroundColor -Color Green
	}
}
function Bdarkyellow {
	process {
		Set-BackgroundColor -Color DarkYellow
	}
}
function Byellow {
	process {
		Set-BackgroundColor -Color Yellow
	}
}
function Bdarkblue {
	process {
		Set-BackgroundColor -Color DarkBlue
	}
}
function Bblue {
	process {
		Set-BackgroundColor -Color Blue
	}
}
function Bdarkmagenta {
	process {
		Set-BackgroundColor -Color DarkMagenta
	}
}
function Bmagenta {
	process {
		Set-BackgroundColor -Color Magenta
	}
}
function Bdarkcyan {
	process {
		Set-BackgroundColor -Color DarkCyan
	}
}
function Bcyan {
	process {
		Set-BackgroundColor -Color Cyan
	}
}

# キー入力を読む関数
function Read-Key {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    switch ($key.VirtualKeyCode) {
        38 { "Up" }
        40 { "Down" }
        37 { "Left" }
        39 { "Right" }
        13 { "CR" }
        8 { "BS" }
        32 { "Space" }
        default { [char]$key.Character }
    }
}
