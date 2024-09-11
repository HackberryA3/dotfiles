param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1

LogInfo "Setup Windows Terminal..." "WINDOWS TERMINAL"

$PackagePath = "${env:LOCALAPPDATA}\Packages"
$WindowsTerminalPath = $(Get-ChildItem -Path $PackagePath -Filter "Microsoft.WindowsTerminal*" | Select-Object -First 1).FullName
$SettingsPath = "${WindowsTerminalPath}\LocalState\settings.json"
if (!Test-Path $SettingsPath) {
	LogError "Windows Terminal is not installed." "WINDOWS TERMINAL"
	Pop-Location
	return 1
}

if (IsAdmin) {
	New-Item -ItemType SymbolicLink -Path $SettingsPath -Target "..\dotfiles\WindowsTerminal_profile.json" -Force
}
else {
	ExecAdmin "-Command New-Item" "-ItemType SymbolicLink -Path $SettingsPath -Target `"..\dotfiles\WindowsTerminal_profile.json`" -Force"
}

LogSuccess "Windows Terminal setup is done." "WINDOWS TERMINAL"

Pop-Location
