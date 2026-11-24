# 彻底卸载：停掉程序、删开机自启、删程序、删设置和日志。Antigravity 本来就没被改过。
param([switch]$Quiet)
Get-Process AntigravityBootAnimation -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 800
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'AntigravityBootAnimation' -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\AntigravityBootAnimation" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\AntigravityBootAnimation" -Recurse -Force -ErrorAction SilentlyContinue
$dest = "$env:LOCALAPPDATA\Programs\AntigravityBootAnimation"
# 删掉启动时写的「用高性能显卡」偏好
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences' -Name "$dest\AntigravityBootAnimation.exe" -ErrorAction SilentlyContinue
# 卸载脚本本身可能就在程序目录里，延后删
Start-Process cmd.exe -ArgumentList "/c timeout /t 2 /nobreak >nul & rmdir /s /q `"$dest`"" -WindowStyle Hidden
if (-not $Quiet) { Write-Host '已卸载干净。' }
