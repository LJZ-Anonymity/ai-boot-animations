#!/bin/zsh
# 维护者用：编译通用版并打包成 build/ClaudeBootAnimation.zip，供上传到 GitHub Releases
# 用法：./release.sh            只打包
#       ./release.sh v1.0.1     打包并用 gh 发布这个版本
set -e
cd "${0:A:h}"
./build.sh
OUT=build/release/ClaudeBootAnimation
rm -rf build/release build/ClaudeBootAnimation.zip; mkdir -p "$OUT"
ditto build/ClaudeBootAnimation.app "$OUT/ClaudeBootAnimation.app"
cp install.sh uninstall.sh ../LICENSE "$OUT/"
cp assets/LICENSE.md "$OUT/ASSETS-LICENSE.md"
ditto -c -k --norsrc --noextattr --keepParent "$OUT" build/ClaudeBootAnimation.zip
echo "压缩包：build/ClaudeBootAnimation.zip（$(du -h build/ClaudeBootAnimation.zip | cut -f1)）"
if [[ -n "$1" ]]; then
  gh release create "$1" build/ClaudeBootAnimation.zip --title "Claude 开机动画 $1" \
    --notes "通用版（Apple 芯片 / Intel），macOS 13+。一行命令安装见 claude/README.md。"
fi
