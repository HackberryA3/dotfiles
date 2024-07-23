using namespace System.Collections;
using namespace System.Collections.Generic;
param(
	[ValidateSet("--all", "--choice", "--cui", "--gui", "--dotfiles", "--help", "-h")][string]$MODE="--choice"
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. .\lib\utility.ps1
. .\lib\ui\log.ps1
. .\lib\ui\choose.ps1

[bool]$CUI=$false
[bool]$GUI=$false
[bool]$CHOICE=$false
[bool]$INSTALL_DOTFILES=$false
[bool]$HasError=$false

function ShowHelp {
	Write-Host "Usage: install.ps1 [options]"
	Write-Host ""
	Write-Host "Options:"
	Write-Host "  --all       Install all components"
	Write-Host "  --choice    You can choose what to install(default)"
	Write-Host "  --cui       Install CUI components"
	Write-Host "  --gui       Install GUI components"
	Write-Host "  --dotfiles  Install dotfiles"
	Write-Host "  --help, -h  Show this help"
}

switch ($MODE) {
	"--all" { $CUI=$true; $GUI=$true; $INSTALL_DOTFILES=$true }
	"--choice" { $CHOICE=$true }
	"--cui" { $CUI=$true }
	"--gui" { $GUI=$true }
	"--dotfiles" { $INSTALL_DOTFILES=$true }
	"--help" { ShowHelp; return }
	"-h" { ShowHelp; return }
}

# OSがWindowsでなければエラー
if ($IsWindows -eq $false) {
	LogError "This script is only for Windows." "INSTALL" | Out-Null
	return
}

function ShowSplash {
	Fgreen
	Write-Host "" `
			" _   _            _    _                             _    _____  `n" `
			"| | | | __ _  ___| | _| |__   ___ _ __ _ __ _   _   / \  |___ /  `n" `
			"| |_| |/ _`` |/ __| |/ / '_ \ / _ \ '__| '__| | | | / _ \   |_ \  `n" `
			"|  _  | (_| | (__|   <| |_) |  __/ |  | |  | |_| |/ ___ \ ___) | `n" `
			"|_| |_|\__,_|\___|_|\_\_.__/ \___|_|  |_|   \__, /_/   \_\____/  `n" `
			"                                            |___/                "
	Fmagenta
	Write-Host "" `
			"                    _       _    __ _ _`n" `
			"                  _| | ___ | |_ / _(_) | ___  ___`n" `
			"                / _`` |/ _ \| __| |_| | |/ _ \/ __|`n" `
			"               | (_| | (_) | |_|  _| | |  __/\__ \ `n" `
			"              (_)__,_|\___/ \__|_| |_|_|\___||___/`n"
	Normal
}

ShowSplash
Start-Sleep -Seconds 2



# CUI、CUIをフィルターするための正規表現を用意する
$FILTER=""
if ($CUI -eq $true -and $GUI -eq $true) {
	$FILTER="(CUI|GUI)"
} elseif ($CUI -eq $true) {
	$FILTER="CUI"
} elseif ($GUI -eq $true) {
	$FILTER="GUI"
}

# スクリプトを検索
[string[]]$SCRIPTS=Get-ChildItem -Path .\scripts -Filter "*.ps1" | Where-Object { $_.Name -match $FILTER -and $_.Name -match "__windows__" } | Select-Object $_.FullName | Sort-Object

if ($CHOICE -eq $true) {
	[List[string]]$Aka=[List[string]]::new()
	[List[string]]$Tags=[List[string]]::new()
	foreach ($SCRIPT in $SCRIPTS) {
		$BASENAME=[System.IO.Path]::GetFileNameWithoutExtension($SCRIPT)
		$Aka.Add($($BASENAME -creplace "__.*__", "" | Snake2Pascal))
		if ($BASENAME -match "__CUI__") {
			$Tags.Add("CUI")
		} elseif ($BASENAME -match "__GUI__") {
			$Tags.Add("GUI")
		}
		else {
			$Tags.Add("")
		}
	}

	$SCRIPTS=Choose -Title "Choose installation scripts" -Options $SCRIPTS -Aka $Aka.ToArray() -Tags $Tags.ToArray()
}

# スクリプトを実行
# エラーが発生したら、標準エラーをRESULTに格納
# エラーは発生していないが、標準エラーに何か出力されている場合は、それをRESULTに格納
# 最後にRESULTをログに出力
class ScriptResult {
	[string]$Name
	[bool]$IsError
	[bool]$IsWarning
	[bool]$IsSuccess
	[ArrayList]$ErrMsg
	[ArrayList]$WarnMsg
}

[List[ScriptResult]]$RESULTS=[List[ScriptResult]]::new()
foreach ($SCRIPT in $SCRIPTS) {
	[string]$SCRIPT_ARGS=if ($CHOICE) { " -Choice " } else { "" }
	Invoke-Expression -Command $($SCRIPT + $SCRIPT_ARGS) -ErrorVariable ERR -WarningVariable WARN | Out-Null
	if (-not $?) {
		$HasError=$true
	}

	$RESULTS.Add([ScriptResult]@{
		Name=$SCRIPT
		IsError=if (-not $? -or $ERR.Count -ne 0) { $true } else { $false }
		IsWarning=if ($WARN.Count -ne 0) { $true } else { $false }
		IsSuccess=if ($? -and $ERR.Count -eq 0 -and $WARN.Count -eq 0) { $true } else { $false }
		ErrMsg=$ERR
		WarnMsg=$WARN
	})
}

foreach($R in $RESULTS) {
	if ($R.IsSuccess) {
		LogSuccess "$($R.Name)" "SCRIPT" | Out-Null
	}
	elseif ($R.IsError) {
		LogError "$($R.Name)" "SCRIPT" | Out-Null
		foreach($E in $R.ErrMsg) {
			Write-Host -NoNewline "`t"
			LogError "$($E | Format-List | Out-String)" | Out-Null
		}
		foreach($W in $R.WarnMsg) {
			Write-Host -NoNewline "`t"
			LogWarning "$($W | Format-List | Out-String)" | Out-Null
		}
	}
	elseif ($R.IsWarning) {
		LogWarning "$($R.Name)" "SCRIPT" | Out-Null
		foreach($W in $R.WarnMsg) {
			Write-Host -NoNewline "`t"
			LogWarning "$($W | Format-List | Out-String)" | Out-Null
		}
	}
}



Pop-Location
