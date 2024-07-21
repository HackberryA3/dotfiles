function SetCursor {
	param(
		[int]$X,
		[int]$Y
	)
	process{
		[Console]::SetCursorPosition($X, $Y)
	}
}

function CursorUp {
	param(
		[int]$Count = 1
	)
	process{
		SetCursor $([Console]::CursorLeft)  $([Console]::CursorTop - $Count)
	}
}
function CursorDown {
	param(
		[int]$Count = 1
	)
	process{
		SetCursor $([Console]::CursorLeft)  $([Console]::CursorTop + $Count)
	}
}
function CursorLeft {
	param(
		[int]$Count = 1
	)
	process{
		SetCursor $([Console]::CursorLeft - $Count)  $([Console]::CursorTop)
	}
}
function CursorRight {
	param(
		[int]$Count = 1
	)
	process{
		SetCursor $([Console]::CursorLeft + $Count)  $([Console]::CursorTop)
	}
}

function CursorBegin {
	process{
		SetCursor 0 $([Console]::CursorTop)
	}
}

function ClearLine {
	process{
		CursorBegin
		[Console]::Write((" " * [Console]::WindowWidth))
		CursorBegin
	}
}
