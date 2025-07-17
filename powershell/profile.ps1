function prompt {
  # Get username, hostname, and current working directory
  $username = [System.Environment]::UserName
  $hostname = $env:COMPUTERNAME
  $cwd = Get-Location

  # Apply colors
  $green = [System.ConsoleColor]::Green
  $blue = [System.ConsoleColor]::Blue
  $white = [System.ConsoleColor]::White

  # Format prompt
  Write-Host "${username}:${hostname}:" -ForegroundColor ${green} -NoNewline
  Write-Host "${cwd}" -ForegroundColor ${blue} -NoNewline
  Write-Host " >" -ForegroundColor $white -NoNewline
  return " "  # Ensures proper input spacing
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
Import-Module "$ChocolateyProfile"
}
