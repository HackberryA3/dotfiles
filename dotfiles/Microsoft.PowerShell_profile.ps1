# Install modules
$LaterThan7_2 = ($PSVersionTable.PSVersion.Major -ge 7) -And ($PSVersionTable.PSVersion.Minor -ge 2)

try { Import-Module -Name PSReadLine -ErrorAction Stop }catch {}
try { Import-Module -Name Terminal-Icons -ErrorAction Stop }catch {}
try { if ($LaterThan7_2) { Import-Module -Name CompletionPredictor -ErrorAction Stop } }catch {}
try {
        Set-PSReadLineOption -EditMode Windows
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle ListView
}
catch { Write-Host "Your PSReadLine version does not support the list view and the plugin." }



# Set up the prompt
try { oh-my-posh init pwsh --config https://gist.githubusercontent.com/HackberryA3/d0d7597c58b14e6397362ec5af05eec7/raw/ReactiveCatppuccin.omp.yaml | Invoke-Expression }catch {}

# Set Aliases
Set-Alias touch New-Item
Set-Alias command -v Get-Command
function grep {
  $input | out-string -stream | select-string $args
}


# Competitive Programming
function atcoder-cs($Name = (Get-Date -Format "yyyy-MM-dd-HH-mm-ss")) {
        dotnet new atcoder --name $Name
        code $Name
}
function atcoder-cpp($Name = (Get-Date -Format "yyyy-MM-dd-HH-mm-ss")) {
        mkdir $Name | cd
        New-Item main.cpp
}
