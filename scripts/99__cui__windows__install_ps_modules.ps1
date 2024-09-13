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
		powershell -NoProfile -ExecutionPolicy RemoteSigned -File $MyInvocation.MyCommand.Path -Installing
		LogSuccess "PowerShell modules is installed." "PS MODULES"
	}
	Get-Command pwsh -ea SilentlyContinue | Out-Null
	if ($? -eq $true)
	{
		pwsh -NoProfile -ExecutionPolicy RemoteSigned -File $MyInvocation.MyCommand.Path -Installing
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

if ($(Get-PackageProvider | Where-Object { $_.Name -eq "NuGet" }).Length -eq 0) {
	LogInfo "NuGet Provider is not installed. Installing..." "PS MODULES"
	Install-PackageProvider -Name NuGet -MinimumVersion 2.5.8.201 -Force -Scope CurrentUser
}

if (!(Get-Module -ListAvailable -Name PSReadLine)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	LogInfo "PSReadLine does not exist. Installing..." "PS MODULES"
	Install-Module -Name PSReadLine -Force -Scope CurrentUser
}
if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	LogInfo "Terminal-Icons does not exist. Installing..." "PS MODULES"
	Install-Module -Name Terminal-Icons -Force -Scope CurrentUser
}
if ($LaterThan7_2 -And !(Get-Module -ListAvailable -Name CompletionPredictor)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	LogInfo "CompletionPredictor does not exist. Installing..." "PS MODULES"
	Install-Module -Name CompletionPredictor -Force -Scope CurrentUser
}

if ($PolicyChanged) { Set-PSRepository -Name PSGallery -InstallationPolicy $PSGalleryPolicy }



Pop-Location
