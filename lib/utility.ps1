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
