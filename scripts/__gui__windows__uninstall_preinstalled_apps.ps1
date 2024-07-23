using namespace System.Collections.Generic;
param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\utility.ps1
. ..\lib\ui\log.ps1
. ..\lib\ui\choose.ps1




class UninstallElement {
    [string]$Tag
    [string]$Name
	[string]$Aka
}

[string]$Current_Tag = ""
[List[UninstallElement]]$Options = [List[UninstallElement]]::new()

# ファイルのパスを指定して読み込み
$filePath = ".\lists\uninstall_preinstalled_apps.list"

# ファイルを一行ずつ読み込んで処理する
Get-Content $filePath | ForEach-Object {
    $line = $_.Trim()

    # 空行ならスキップ
    if ([string]::IsNullOrWhiteSpace($line)) {
        return
    }

    # タグを処理
    if ($line -match '^\s*#') {
        $Current_Tag = $line -replace '^\s*#\s*', '' -replace '\s*-+$', ''
		$Current_Tag = $Current_Tag.Trim()
    } else {
        # 選択肢を処理
        $option = $line
		$aka = $option
        if ($option -match '#') {
            $option, $comment = $option -split '\s*#\s*', 2
            $aka = "$option - $comment"
        }
		$option = $option.Trim()
		$aka = $aka.Trim()

        $Options.Add([UninstallElement]@{
			Tag = $Current_Tag
			Name = $option
			Aka = $aka})
    }
}

if ($Choice) {
	$RES=$(Choose -Options $($Options | ForEach-Object { $_.Name }) -Title "Choose the apps to uninstall" -Tags $($Options | ForEach-Object {$_.Tag}) -Aka $($Options | ForEach-Object {$_.Aka}))

	$Options.Clear()
	$RES | ForEach-Object {
		$Options.Add([UninstallElement]@{
			Tag = ""
			Name = $_
			Aka = ""})
	}
}


foreach ($Option in $Options) {
	$Name = $Option.Name

	LogInfo "Uninstalling $Name..." "UNINSTALL PREINSTALLED APPS"
	Get-AppxPackage $Name | Remove-AppxPackage
}


Pop-Location
