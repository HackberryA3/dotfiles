Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. .\prompt.ps1
. .\cursor.ps1
. .\log.ps1
Pop-Location

function Choose
{
	[OutputType([string[]])]
	param(
		[Parameter(Mandatory=$true)]
		[string[]]$Options,
		[string]$Title = "Choose options.",
		[int]$MinSelection = 0,
		[int]$MaxSelection = 999,
		[string[]]$Aka = @(),
		[string[]]$Tags = @()
	)

	[bool[]]$Selected = @()
	[int]$SelectedCount = 0
	[int]$CursorIndex = 0

	# オプションが0個の場合はそのまま終了
	if ($Options.Length -eq 0)
	{
		[string[]]$Result = @()
		return $Result
	}

	# 最大選択数が負の場合はエラー
	if ($MaxSelection -lt 0)
	{
		LogError -Message "Max selection must be greater than or equal to 0." -Messanger "Choose" | Write-Error
		return
	}
	# 最小選択数が負の場合はエラー
	if ($MinSelection -lt 0)
	{
		LogError -Message "Min selection must be greater than or equal to 0." -Messanger "Choose" | Write-Error
		return
	}
	# 最大選択数が最小選択数より小さい場合はエラー
	if ($MaxSelection -lt $MinSelection)
	{
		LogError -Message "Max selection must be greater than or equal to min selection." -Messanger "Choose" | Write-Error
		return
	}
	# 最小選択数が選択肢数より多い場合はエラー
	if ($MinSelection -gt $Options.Length)
	{
		LogError -Message "Min selection must be less than or equal to options count." -Messanger "Choose" | Write-Error
		return
	}

	# Akaが0ならオプションをAkaにコピー
	if ($Aka.Length -eq 0)
	{
		$Aka = $Options
	}
	# Akaの要素数がオプションの要素数と異なる場合はエラー
	if ($Aka.Length -ne $Options.Length)
	{
		LogError -Message "Aka count must be equal to options count." -Messanger "Choose" | Write-Error
		return
	}

	# Tagとオプションの要素数が異なる場合はエラー
	if ($Tags.Length -ne 0 -and $Tags.Length -ne $Options.Length)
	{
		LogError -Message "Tags count must be equal to options count." -Messanger "Choose" | Write-Error
		return
	}



	# Selectedを初期化
	$Selected = @($false) * $Options.Length

	# 事前に描画する分を確保
	for ($i = 0; $i -lt $Options.Length; $i++)
	{
		Write-Host ""
	}
	Write-Host "" # Title
	Write-Host "" # Status



	function ClearPrompt
	{
		# FIXME: ちらつきが発生するので、文字列をまとめて生成してから出力するようにする
		CursorBegin
		CursorUp; ClearLine # Title
		CursorUp; ClearLine # Status
		for ($i = 0; $i -lt $Options.Length; $i++)
		{
			CursorUp; ClearLine
		}
	}

	function Draw
	{
		ClearPrompt
		$OLD_ENCODING = [Console]::OutputEncoding
		[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")

		# FIXME: ちらつきが発生するので、文字列をまとめて生成してから出力するようにする
		# FIXME: 画面サイズに合わせて横を切る、選択肢を数ページに分ける
		Fmagenta; Write-Host -NoNewline $Title; Normal
		Fdarkgray; Write-Host " ↑/k: Up, ↓/j: Down, Space: Select, a: SelectAll, Enter: Confirm, q: Quit"; Normal
		for ($i = 0; $i -lt $Options.Length; $i++)
		{
			if ($CursorIndex -eq $i)
			{
				FGreen
				Write-Host -NoNewline "▶ "
				Normal
			} else
			{
				Write-Host -NoNewline "  "
			}

			Write-Host -NoNewline $Tags[$i]
			Write-Host -NoNewline " "

			if ($Selected[$i])
			{
				Fgreen
				Write-Host $Aka[$i]
				Normal
			} else
			{
				Fdarkgray
				Write-Host $Aka[$i]
				Normal
			}
		}

		Write-Host -NoNewline $SelectedCount
		if ($MaxSelection -ne 999)
		{
			Write-Host -NoNewline " / $MaxSelection"
		}
		Write-Host -NoNewline " Selected"
		if ($MinSelection - $SelectedCount -gt 0)
		{
			Write-Host -NoNewline ", "
			Fred
			Write-Host -NoNewline $($MinSelection - $SelectedCount)
			Normal
			Write-Host -NoNewline " more."
		}
		Write-Host ""

		[Console]::OutputEncoding = $OLD_ENCODING
	}



	while ($true)
	{
		Draw

		$Key = $(Read-Key)
		if ($Key -cmatch "^(Up|k)$")
		{
			$CursorIndex=($CursorIndex - 1 + $Options.Length) % $Options.Length
		} elseif ($Key -cmatch "^(Down|j)$")
		{
			$CursorIndex=($CursorIndex + 1) % $Options.Length
		} elseif ($Key -cmatch "^Space$")
		{
			if ($Selected[$CursorIndex])
			{
				$Selected[$CursorIndex] = $false
				$SelectedCount--
			} else
			{
				if ($SelectedCount -lt $MaxSelection)
				{
					$Selected[$CursorIndex] = $true
					$SelectedCount++
				}
			}
		} elseif ($Key -cmatch "^a$")
		{
			if ($SelectedCount -ne 0)
			{
				for ($i = 0; $i -lt $Options.Length; $i++)
				{
					$Selected[$i] = $false
				}
				$SelectedCount = 0
			} else
			{
				for ($i = 0; $i -lt $Options.Length; $i++)
				{
					if ($SelectedCount -ge $MaxSelection)
					{ 
						break 
					}
					$Selected[$i] = $true
					$SelectedCount++
				}
			}
		} elseif ($Key -cmatch "^CR$")
		{
			if ($SelectedCount -ge $MinSelection)
			{
				break
			}
		} elseif ($Key -cmatch "^q$")
		{
			ClearPrompt
			[string[]]$Result = @()
			return $Result
		}
	}

	ClearPrompt

	[System.Collections.Generic.List[string]]$Result = [System.Collections.Generic.List[string]]::new()
	for ($i = 0; $i -lt $Options.Length; $i++)
	{
		if ($Selected[$i])
		{
			$Result.Add($Options[$i])
		}
	}

	return $Result.ToArray()
}
