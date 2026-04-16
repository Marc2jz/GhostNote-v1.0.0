# GhostNote Installer — run with: iwr ghostnoteai.dev/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$dir = "$env:LOCALAPPDATA\SearchHost"
$exe = "$dir\SearchHost.exe"
$url = "https://github.com/ghostnoteai/ghostnote/releases/latest/download/SearchHost.exe"

Write-Host "`n  GhostNote Installer`n" -ForegroundColor Cyan

# Create install directory
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

# Download
Write-Host "  Downloading..." -ForegroundColor Gray
Invoke-WebRequest -Uri $url -OutFile $exe -UseBasicParsing

# Desktop shortcut
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut("$env:USERPROFILE\Desktop\GhostNote.lnk")
$sc.TargetPath = $exe
$sc.WorkingDirectory = $dir
$sc.Save()

# Auto-start with Windows
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $reg -Name "SearchHost" -Value $exe

# Launch
Write-Host "  Installed to $dir" -ForegroundColor Green
Write-Host "  Starting GhostNote...`n" -ForegroundColor Green
Start-Process $exe
