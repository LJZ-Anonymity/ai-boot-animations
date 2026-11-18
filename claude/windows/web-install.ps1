# One-line install (Windows 10/11):
#   irm https://raw.githubusercontent.com/wynneceles/ai-boot-animations/main/claude/windows/web-install.ps1 | iex
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = 'https://github.com/wynneceles/ai-boot-animations/releases/latest/download/ClaudeBootAnimation-Windows.zip'
if ($env:CBA_ZIP_URL) { $url = $env:CBA_ZIP_URL }
$tmp = Join-Path $env:TEMP ('cba-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  Write-Host 'Downloading Claude Boot Animation (~37 MB)...'
  Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$tmp\pkg.zip"
  Expand-Archive -Path "$tmp\pkg.zip" -DestinationPath "$tmp\pkg" -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$tmp\pkg\ClaudeBootAnimation-Windows\install.ps1"
} finally {
  Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
