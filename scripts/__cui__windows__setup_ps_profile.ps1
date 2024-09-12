param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\choose.ps1
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1

LogInfo "Setup Powershell Profile..." "PS PROFILE"

[string[]]$Choices = @(
	"${env:USERPROFILE}\Documents\Powershell\Microsoft.Powershell_profile.ps1",
	"${env:USERPROFILE}\Documents\WindowsPowershell\Microsoft.Powershell_profile.ps1",
	"${env:USERPROFILE}\Documents\Powershell\Microsoft.VSCode_profile.ps1"
)
[string[]]$Aka = @(
	"PWSH",
	"WindowsPowershell",
	"VSCode"
)

if ($Choice) {
	$Choices= Choose -Choices $Choices -Aka $Aka -Title "Choose profile to setup"
}

foreach ($c in $Choices) {
	if (IsAdmin) {
		New-Item -ItemType SymbolicLink -Path $c -Target "..\dotfiles\Microsoft.Powershell_profile.ps1" -Force
	}
	else {
		ExecAdmin "-Command New-Item" "-ItemType SymbolicLink -Path $c -Target `"$(Get-Location)..\dotfiles\Microsoft.Powershell_profile.ps1`" -Force"
	}
}

LogSuccess "Powershell Profile setup is done." "PS PROFILE"

Pop-Location
