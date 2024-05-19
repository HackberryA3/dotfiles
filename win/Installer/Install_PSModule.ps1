param (
	[string]$ForPWSH = "False"
)

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Check pwsh
if ($ForPWSH -match "(True)|(true)") {
	Write-Host "Installing for pwsh..."
	try {
		pwsh.exe -ExecutionPolicy RemoteSigned -File Install_PSModule.ps1
	}
	catch { Write-Host "pwsh does not exist." }
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

	Write-Host "PSReadLine does not exist. Installing..."
	Install-Module -Name PSReadLine -Scope CurrentUser
}
if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	Write-Host "Terminal-Icons does not exist. Installing..."
	Install-Module -Name Terminal-Icons -Scope CurrentUser
}
if ($LaterThan7_2 -And !(Get-Module -ListAvailable -Name CompletionPredictor)) {
	$PolicyChanged = (SetTrustedPSGalleryPolicy)[-1]

	Write-Host "CompletionPredictor does not exist. Installing..."
	Install-Module -Name CompletionPredictor -Scope CurrentUser
}

if ($PolicyChanged) { Set-PSRepository -Name PSGallery -InstallationPolicy $PSGalleryPolicy }