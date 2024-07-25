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
