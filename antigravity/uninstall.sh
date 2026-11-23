#!/bin/zsh
# 彻底卸载：停掉常驻、删登录项、删小程序、删设置和日志。Antigravity.app 本来就没被改过。
UID_=$(id -u)
for L in io.github.celestewynne0506-pixel.antigravity-boot-animation; do
  launchctl bootout "gui/$UID_/$L" 2>/dev/null
  rm -f "$HOME/Library/LaunchAgents/$L.plist"
done
pkill -f 'AntigravityBootAnimation.app/Contents/MacOS/AntigravityBootAnimation' 2>/dev/null
rm -rf "$HOME/Applications/AntigravityBootAnimation.app"
rm -rf "$HOME/Library/Application Support/AntigravityBootAnimation"
rm -f  "$HOME/Library/Logs/AntigravityBootAnimation.log"
defaults delete io.github.celestewynne0506-pixel.antigravity-boot-animation 2>/dev/null
echo "已卸载干净。"
