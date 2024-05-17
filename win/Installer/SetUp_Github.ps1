$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Git: Set up Git
$email = Read-Host "Your Email for Git"
while (-not ($email -match '^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$')) {
	Write-Host "Invalid email format. Please enter a valid email address."
	$email = Read-Host "Your Email for Git"
}

$name = Read-Host "Your Name for Git"
while (-not ($name -match '^[a-zA-Z\s]+$')) {
	Write-Host "Invalid name format. Please enter a valid name."
	$name = Read-Host "Your Name for Git"
}

git config --global user.email $email
git config --global user.name $name

# GitHub: Set up GitHub
gh auth login
gh auth setup-git
