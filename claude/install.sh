#!/bin/zsh
# 编译 → 装到 ~/Applications → 设为登录自动启动 → 弹出设置窗口
# 不会修改 Claude.app 的任何文件
set -e
cd "${0:A:h}"
./build.sh
LABEL=io.github.celestewynne0506-pixel.claude-boot-animation
DEST="$HOME/Applications/ClaudeBootAnimation.app"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
UID_=$(id -u)
# 先停掉旧版本（包括早期测试版用过的标识）
for L in "$LABEL" io.github.celeste.claude-boot-animation; do
  launchctl bootout "gui/$UID_/$L" 2>/dev/null || true
  rm -f "$HOME/Library/LaunchAgents/$L.plist"
done
pkill -f 'ClaudeBootAnimation.app/Contents/MacOS/ClaudeBootAnimation' 2>/dev/null || true
mkdir -p "$HOME/Applications" "$HOME/Library/LaunchAgents"
rm -rf "$DEST"; cp -R build/ClaudeBootAnimation.app "$DEST"
cat > "$PLIST" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key><array><string>$DEST/Contents/MacOS/ClaudeBootAnimation</string></array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><dict><key>SuccessfulExit</key><false/></dict>
  <key>ProcessType</key><string>Interactive</string>
</dict></plist>
PL
launchctl bootstrap "gui/$UID_" "$PLIST"
sleep 1.5
open "$DEST"   # 已在运行时再打开一次 = 弹出设置窗口
echo
echo "✨ 装好了！菜单栏右边（电池左边）出现 ✨ 图标，也弹出了设置窗口。"
echo "   下次打开 Claude 就会播放开机动画。想马上看：菜单栏 ✨ →「播放一次开屏动画」。"
