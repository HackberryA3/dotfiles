param(
	[switch]$Installing=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1

LogInfo "Install PS Modules..." "PS MODULES"

RefreshEnv

if (-not $Installing) {
	Get-Command powershell -ea SilentlyContinue | Out-Null
	if ($? -eq $true)
	{
		powershell -ExecutionPolicy RemoteSigned -File Install_PSModule.ps1 -Installing
		LogSuccess "PowerShell modules is installed." "PS MODULES"
	}
	Get-Command pwsh -ea SilentlyContinue | Out-Null
	if ($? -eq $true)
	{
		pwsh -ExecutionPolicy RemoteSigned -File Install_PSModule.ps1 -Installing
		LogSuccess "Pwsh modules is installed." "PS MODULES"
	}



	Pop-Location
	return 0
}

$LaterThan7_2 = ($PSVersionTable.PSVersion.Major -ge 7) -And ($PSVersionTable.PSVersion.Minor -ge 2)

function GetPSGalleryPolicy {
	return (Get-PSRepository -Name PSGallery).InstallationPolicy
}
function SetTrustedPSGalleryPolicy {
	if (GetPSGalleryPolicy -ne "Trusted") {
		Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
		return $true
	}
	return $false
}
$PSGalleryPolicy = GetPSGalleryPolicy
$PolicyChanged = $false

if (!(Get-Module -ListAvailable -Name PSReadLine)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	LogInfo "PSReadLine does not exist. Installing..." "PS MODULES"
	Install-Module -Name PSReadLine -Scope CurrentUser
}
if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	LogInfo "Terminal-Icons does not exist. Installing..." "PS MODULES"
	Install-Module -Name Terminal-Icons -Scope CurrentUser
}
if ($LaterThan7_2 -And !(Get-Module -ListAvailable -Name CompletionPredictor)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	LogInfo "CompletionPredictor does not exist. Installing..." "PS MODULES"
	Install-Module -Name CompletionPredictor -Scope CurrentUser
}

if ($PolicyChanged) { Set-PSRepository -Name PSGallery -InstallationPolicy $PSGalleryPolicy }



Pop-Location
