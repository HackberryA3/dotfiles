function Snake2Pascal {
	[OutputType([string])]
	param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[string]$Str
	)
	process {
		return [regex]::replace($Str.ToLower(), '(^|_)(.)', { $args[0].Groups[2].Value.ToUpper()})
	}
}

function RefreshEnv {
	$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

function IsAdmin {
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function ExecAdmin {
	param(
	  [Parameter(Mandatory = $true)][string]$Script,
	  [string]$Param
	)
	Get-Command pwsh -ea SilentlyContinue | Out-Null
	if ($?) {
		Start-Process pwsh "-NoProfile", $Script, $Param -Verb RunAs -Wait
	}
	else {
		Start-Process powershell "-NoProfile", $Script, $Param -Verb RunAs -Wait
	}
}
