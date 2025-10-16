function prompt {
  # Get username, hostname, and current working directory
  $username = [System.Environment]::UserName
  $hostname = $env:COMPUTERNAME
  $cwd = Get-Location

  # Apply colors
  $green = [System.ConsoleColor]::DarkGreen
  $blue = [System.ConsoleColor]::DarkCyan
  $white = [System.ConsoleColor]::White

  # Format prompt
  Write-Host "${username}@${hostname}:" -ForegroundColor ${green} -NoNewline
  Write-Host "${cwd}" -ForegroundColor ${blue} -NoNewline
  Write-Host " >" -ForegroundColor $white -NoNewline
  return " "
}

Set-Alias n nvim.exe
Set-Alias lg lazygit.exe
function Remove-ForceRecurse { Remove-Item -Force -Recurse @args }; Set-Alias rf Remove-ForceRecurse

function vs {
  & {
    Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell 661b5f87 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"
  }
}
