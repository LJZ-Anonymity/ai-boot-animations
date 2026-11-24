# One-line install (Windows 10/11):
#   irm https://raw.githubusercontent.com/wynneceles/ai-boot-animations/main/antigravity/windows/web-install.ps1 | iex
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Shares the repo with the Claude version (which owns releases/latest), so pin the Gemini tag here. Bump together with antigravity/web-install.sh.
$tag = 'gemini-v1.1.0'
$url = "https://github.com/wynneceles/ai-boot-animations/releases/download/$tag/AntigravityBootAnimation-Windows.zip"
if ($env:AGBA_ZIP_URL) { $url = $env:AGBA_ZIP_URL }
$tmp = Join-Path $env:TEMP ('agba-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  Write-Host 'Downloading Gemini Boot Animation (~60 MB)...'
  Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$tmp\pkg.zip"
  Expand-Archive -Path "$tmp\pkg.zip" -DestinationPath "$tmp\pkg" -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$tmp\pkg\AntigravityBootAnimation-Windows\install.ps1"
} finally {
  Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
