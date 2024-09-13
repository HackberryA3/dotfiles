param(
	[switch]$Choice=$false
)

Push-Location $(Get-Location)
$MyInvocation.MyCommand.Path | Split-Path | Set-Location
. ..\lib\ui\log.ps1
. ..\lib\utility.ps1
Pop-Location

LogInfo "Setup git configuration..." "GIT"

RefreshEnv

Get-Command git -ea SilentlyContinue | Out-Null
if ($? -eq $false)
{
	LogError "Git is not installed." "GIT" | Write-Error
	return 1
}

git config --global init.defaultBranch main
git config --global pull.ff only

git config --global core.autocrlf false
git config --global core.quotepath false
git config --global core.ignorecase false
git config --global core.editor nvim

git config --global color.ui true
git config --global grep.lineNumber true

git config --global alias.graph "log --pretty=format:'%Cgreen[%cd] %Cblue%h %Cred<%cn> %Creset%s' --date=short  --decorate --graph --branches --tags --remotes"

if (-not $Choice) {
	LogSuccess "Git configuration is done (not choice mode)." "GIT"
	return 0
}

Read-Host "Your email address for git" | git config --global user.email
Read-Host "Your name for git" | git config --global user.name

$ToSetupCLI = Read-Host "Do you want to setup GitHub CLI? (Y/n)"
if ($ToSetupCLI -eq "Y" -or $ToSetupCLI -eq "y") {
	Get-Command gh -ea SilentlyContinue | Out-Null
	if ($? -eq $true)
	{
		gh auth login
		gh auth setup-git
	}
}

LogSuccess "Git configuration is done." "GIT"
return 0
