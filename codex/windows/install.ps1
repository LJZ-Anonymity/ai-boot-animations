# 编译 → 装到非系统盘（剩余空间最大的那块，比如 D:\AIBootAnimations\GPTBootAnimation）→ 设为开机自启 → 弹出设置窗口
# 只有 C 盘、或别的盘写不进去时才装到 %LOCALAPPDATA%\Programs。想自己指定：-Dir E:\某目录 或先设 $env:GBA_DIR
# 不会修改 ChatGPT 的任何文件
param([string]$Dir)
$ErrorActionPreference = 'Stop'
$name = 'GPTBootAnimation'
function Test-Writable([string]$p) {
  try { New-Item -ItemType Directory -Force -Path $p | Out-Null; $f = Join-Path $p ('.w' + [guid]::NewGuid().ToString('N')); [IO.File]::WriteAllText($f, ''); Remove-Item $f -Force; return $true } catch { return $false }
}
if (-not $Dir) { $Dir = $env:GBA_DIR }
if (-not $Dir) {
  $disks = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue | Where-Object { $_.DeviceID -ne $env:SystemDrive -and $_.FreeSpace -gt 1GB } | Sort-Object FreeSpace -Descending)
  foreach ($d in $disks) { $p = "$($d.DeviceID)\AIBootAnimations"; if (Test-Writable $p) { $Dir = $p; break } }
  if (-not $Dir) { $Dir = "$env:LOCALAPPDATA\Programs" }
}
if (-not (Test-Writable $Dir)) { throw "装不进 $Dir（没有写入权限）" }
$dest = Join-Path $Dir $name
Get-Process $name -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500
# 以前装在别处（比如老版本装在 C 盘）：先删掉旧的，免得留两份
$run = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$old = (Get-ItemProperty -Path $run -Name $name -ErrorAction SilentlyContinue).$name
if ($old) {
  $oldDir = Split-Path ($old.Trim('"')) -Parent
  if ($oldDir -and ($oldDir.TrimEnd('\') -ne $dest.TrimEnd('\')) -and (Test-Path "$oldDir\$name.exe")) {
    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences' -Name "$oldDir\$name.exe" -ErrorAction SilentlyContinue
    Remove-Item $oldDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
& "$PSScriptRoot\build.ps1" -Out $dest
Set-ItemProperty -Path $run -Name $name -Value "`"$dest\$name.exe`""
Start-Process "$dest\$name.exe" -ArgumentList '--settings'
Write-Host ''
Write-Host "🌙 装好了！装在 $dest"
Write-Host '   右下角托盘出现月亮图标，也弹出了设置窗口。'
Write-Host '   下次打开 ChatGPT 就会播放开机动画。想马上看：托盘月亮图标右键 →「播放一次开屏动画」。'
