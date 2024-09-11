param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1

LogInfo "Install Netcat..." "NETCAT"

$InstallationPath = "C:\Program Files\Netcat"
curl -o netcat.zip https://github.com/diegocr/netcat/archive/refs/heads/master.zip
Expand-Archive -Path netcat.zip -DestinationPath netcat
if (Test-Path $InstallationPath) {
	ExecAdmin "-Command Remove-Item" "-Path $InstallationPath -Recurse -Force"
}
ExecAdmin "-Command Move-Item" "-Path netcat -Destination $InstallationPath"

Remove-Item netcat.zip -Force
Remove-Item netcat -Recurse -Force

LogSuccess "Netcat installation is done." "NETCAT"

Pop-Location

