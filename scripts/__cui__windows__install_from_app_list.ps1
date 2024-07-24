using namespace System.Collections.Generic;
param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\utility.ps1
. ..\lib\ui\log.ps1
. ..\lib\ui\choose.ps1




class InstallElement {
    [string]$Tag
    [string]$Name
	[string]$Aka
}

[List[List[InstallElement]]]$Options = [List[List[InstallElement]]]::new()

# ファイルを検索
$Lists = Get-ChildItem -Path ".\lists" -Filter "*.list" | Where-Object { $_.Name -match "__windows__" } | ForEach-Object { $_.FullName }

foreach($list in $Lists) {
# ファイルを一行ずつ読み込んで処理する
	[string]$Current_Tag = ""
	[List[InstallElement]]$CurrentOptions = [List[InstallElement]]::new()
	Get-Content $list | ForEach-Object {
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

			$CurrentOptions.Add([InstallElement]@{
				Tag = $Current_Tag
				Name = $option
				Aka = $aka})
		}
	}

	$Options.Add($CurrentOptions)
}

if ($Choice) {
	for ($i = 0; $i -lt $Options.Count; $i++) {
		$Option = $Options[$i]
		$listName = Snake2Pascal $([System.IO.Path]::GetFileNameWithoutExtension($Lists[$i]) -replace "__windows__", "")
		$opt = $($Option | ForEach-Object {$_.Name})
		$tag = $($Option | ForEach-Object {$_.Tag})
		$aka = $($Option | ForEach-Object {$_.Aka})
		$RES=$(Choose -Options $opt -Title "Choose the apps to install from $listName" -Tags $tag -Aka $aka)

		$Options[$i].Clear()
		$RES | ForEach-Object {
			$Options[$i].Add([InstallElement]@{
				Tag = ""
				Name = $_
				Aka = ""})
		}
	}
}


for ($i = 0; $i -lt $Options.Count; $i++) {
	$Option = $Options[$i]
	if ($Option.Count -eq 0) {
		continue
	}

	LogInfo "Installing apps from $($Lists[$i])..." "INSTALL FROM APP LIST"
	foreach ($app in $Option) {
		$Name = $app.Name
		LogInfo "Installing $Name..." "INSTALL FROM APP LIST"
		winget install $Name --accept-package-agreements --accept-source-agreements
	}
}


Pop-Location
