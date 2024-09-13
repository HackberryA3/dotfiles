param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1

LogInfo "Install Netcat..." "NETCAT"

$OldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"
$InstallationPath = "C:\Program Files\Netcat"
try {
	curl -o netcat.zip https://github.com/diegocr/netcat/archive/refs/heads/master.zip
	Expand-Archive -Path netcat.zip -DestinationPath netcat
	if (IsAdmin) {
		if (Test-Path $InstallationPath) {
			Remove-Item -Path $InstallationPath -Recurse -Force
		}
		Move-Item -Path "$(Get-Location)\netcat\netcat-master" -Destination $InstallationPath
	}
	else {
		if (Test-Path $InstallationPath) {
			ExecAdmin "-Command Remove-Item" "-Path `"$InstallationPath`" -Recurse -Force"
		}
		ExecAdmin "-Command Move-Item" "-Path `"$(Get-Location)\netcat\netcat-master`" -Destination `"$InstallationPath`""
	}

	Remove-Item netcat.zip -Force
	Remove-Item netcat -Recurse -Force

	[Environment]::SetEnvironmentVariable("Path", "$([Environment]::GetEnvironmentVariable("Path", "Machine"));$InstallationPath", [System.EnvironmentVariableTarget]::Machine)

	LogSuccess "Netcat installation is done." "NETCAT"
}
catch {
	if (Test-Path netcat.zip) {
		Remove-Item netcat.zip -Force
	}
	if (Test-Path netcat) {
		Remove-Item netcat -Recurse -Force
	}

	LogError "Failed to install Netcat." "NETCAT"
}
finally {
	$ErrorActionPreference = $OldErrorActionPreference
}

Pop-Location

