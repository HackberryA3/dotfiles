param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\choose.ps1
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1
Pop-Location

LogInfo "Install Microsoft Office..." "OFFICE"

$Products = @(
	"<ExcludeApp ID=`"Access`" />",
	"<ExcludeApp ID=`"Outlook`" />",
	"<ExcludeApp ID=`"Groove`" />",
	"<ExcludeApp ID=`"Publisher`" />",
	"<ExcludeApp ID=`"Lync`" />",
	"<ExcludeApp ID=`"Excel`" />",
	"<ExcludeApp ID=`"Word`" />",
	"<ExcludeApp ID=`"PowerPoint`" />",
	"<ExcludeApp ID=`"Teams`" />",
	"<ExcludeApp ID=`"OneNote`" />",
	"<ExcludeApp ID=`"OneDrive`" />"
)
$Aka = @(
	"Access",
	"Outlook",
	"Groove",
	"Publisher",
	"Lync",
	"Excel",
	"Word",
	"PowerPoint",
	"Teams",
	"OneNote",
	"OneDrive"
)

[string[]]$Choice= Choose -Options $Products -Aka $Aka -Title "Choose products to exclude"

[string]$TemplateBegin = @"
<Configuration>
	<Add OfficeClientEdition="64" Channel="Current">
		<Product ID="O365BusinessRetail">
			<Language ID="ja-jp" />

"@
[string]$TemplateEnd = @"
		</Product>
	</Add>
	<Updates Enabled="TRUE" />
	<RemoveMSI />
	<Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@
[string]$Exclution = ""
foreach ($c in $Choice) {
	$Exclution += "`t`t`t" + $c + "`n"
}
[string]$Config = $TemplateBegin + $Exclution + $TemplateEnd

$TempFile = New-TemporaryFile
Out-File -FilePath $TempFile -InputObject $Config -Encoding utf8

winget install Microsoft.Office --override "/configure $TempFile"

Remove-Item -Path $TempFile

LogSuccess "Microsoft Office installation is done." "OFFICE"

