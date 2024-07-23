Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. .\prompt.ps1
Pop-Location

function Log {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Message,
		[Paramater(Mandatory=$true)]
		[string]$Head,
		[string]$Messanger=""
	)
	process {
		if ($Messanger.Length -ne 0) {
			BCyan; Fblack
			Write-Host -NoNewline " $Messanger "
			Normal
		}

		Bblue; Fblack
		Write-Host -NoNewline " $Head "
		Normal

		Bdarkgray; Fblue
		Write-Host " $Message "
		Normal

		return "${Messanger}: [$Head] $Message "
	}
}

function LogInfo {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Message,
		[string]$Messanger=""
	)
	process {
		if ($Messanger.Length -ne 0) {
			BCyan; Fblack
			Write-Host -NoNewline " $Messanger "
			Normal
		}

		Bblue; Fblack
		Write-Host -NoNewline " INFO "
		Normal

		Bdarkgray; Fblue
		Write-Host " $Message "
		Normal

		return "${Messanger}: [INFO] $Message "
	}
}

function LogSuccess {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Message,
		[string]$Messanger=""
	)
	process {
		if ($Messanger.Length -ne 0) {
			BCyan; Fblack
			Write-Host -NoNewline " $Messanger "
			Normal
		}

		Bgreen; Fblack
		Write-Host -NoNewline " SUCCESS "
		Normal

		Bdarkgray; Fgreen
		Write-Host " $Message "
		Normal

		return "${Messanger}: [SUCCESS] $Message "
	}
}

function LogWarning {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Message,
		[string]$Messanger=""
	)
	process {
		if ($Messanger.Length -ne 0) {
			BCyan; Fblack
			Write-Host -NoNewline " $Messanger "
			Normal
		}

		Byellow; Fblack
		Write-Host -NoNewline " WARNING "
		Normal

		Bdarkgray; Fyellow
		Write-Host " $Message "
		Normal

		return "${Messanger}: [WARNING] $Message "
	}
}

function LogError {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Message,
		[string]$Messanger=""
	)
	process {
		if ($Messanger.Length -ne 0) {
			BCyan; Fblack
			Write-Host -NoNewline " $Messanger "
			Normal
		}

		Bred; Fblack
		Write-Host -NoNewline " ERROR "
		Normal

		Bdarkgray; Fred
		Write-Host " $Message "
		Normal

		return "${Messanger}: [ERROR] $Message "
	}
}
