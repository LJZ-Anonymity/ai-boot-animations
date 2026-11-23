#!/bin/zsh
# 维护者用：打包 Mac 通用版 build/AntigravityBootAnimation.zip，供上传到 GitHub Releases（目前只有 Mac 版）
# 用法：./release.sh                 只打包
#       ./release.sh gemini-v1.0.0   打包并用 gh 发布这个版本
set -e
cd "${0:A:h}"
./build.sh
OUT=build/release/AntigravityBootAnimation
rm -rf build/release build/AntigravityBootAnimation.zip; mkdir -p "$OUT"
ditto build/AntigravityBootAnimation.app "$OUT/AntigravityBootAnimation.app"
cp install.sh uninstall.sh ../LICENSE CREDITS.md "$OUT/"
cp assets/LICENSE.md "$OUT/ASSETS-LICENSE.md"
ditto -c -k --norsrc --noextattr --keepParent "$OUT" build/AntigravityBootAnimation.zip
echo "压缩包：build/AntigravityBootAnimation.zip（$(du -h build/AntigravityBootAnimation.zip | cut -f1)）"

# 和 Claude 版共用一个仓库，所以：版本号用 gemini- 开头，并且标成「不是最新」，
# 免得抢走 Claude 版一行安装要用的 releases/latest。发完记得把 web-install.sh 里的 TAG 改成新版本号。
if [[ -n "$1" ]]; then
  [[ "$1" == gemini-* ]] || { echo "版本号要以 gemini- 开头，例如 gemini-v1.0.0"; exit 1; }
  gh release create "$1" build/AntigravityBootAnimation.zip --latest=false --title "Gemini 开机动画 $1" \
    --notes "${NOTES:-Antigravity 开机动画（Gemini 双剑少女），macOS 13+（Apple 芯片 / Intel）。一行命令安装见 antigravity/README.md。}"
fi
