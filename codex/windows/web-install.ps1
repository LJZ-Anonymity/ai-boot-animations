# One-line install (Windows 10/11):
#   irm https://raw.githubusercontent.com/wynneceles/ai-boot-animations/main/codex/windows/web-install.ps1 | iex
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Shares the repo with the Claude version (which owns releases/latest), so pin the GPT tag here. Bump together with codex/web-install.sh.
$tag = 'gpt-v1.2.0'
$url = "https://github.com/wynneceles/ai-boot-animations/releases/download/$tag/GPTBootAnimation-Windows.zip"
if ($env:GBA_ZIP_URL) { $url = $env:GBA_ZIP_URL }
$tmp = Join-Path $env:TEMP ('gba-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  Write-Host 'Downloading GPT Boot Animation (~35 MB)...'
  Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$tmp\pkg.zip"
  Expand-Archive -Path "$tmp\pkg.zip" -DestinationPath "$tmp\pkg" -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$tmp\pkg\GPTBootAnimation-Windows\install.ps1"
} finally {
  Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
