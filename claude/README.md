# Claude 开机动画 · Claude Boot Animation

> 属于 [ai-boot-animations](../README.md) 合集。

给 Mac 版 Claude 桌面端加一段开机动画：每次打开 Claude，先在窗口上播放一段持剑少女的开屏，进入循环画面后慢慢透出真正的 Claude 界面，留下一层半透明的动态背景。

![预览](docs/preview.jpg)

- 🎬 **开屏动画**：金色线稿 → 上色 → 睁眼、剑光、火凤、烟花，带音效和英文花体字幕
- 🌙 **循环背景**：开屏结束后半透明循环播放，点击直接穿透到 Claude，不影响使用
- ⏭ **跳过**：开屏时右上角有「跳过」，点了会淡出接到循环背景
- ✨ **菜单栏随时调**：开屏开关、循环背景开关、背景不透明度、开屏音量、背景音量，拖滑块实时生效（[详细说明](#菜单栏--能干什么)）
- 🧼 **不改 Claude 本体**：它是一个独立的小程序，盖在 Claude 窗口上播放；Claude 自动更新、签名、权限都不受影响，卸载后什么都不留

> 非官方同人项目，与 Anthropic 无关。Claude 是 Anthropic 的商标。

## 安装

需要 **macOS 13 或更新**，以及 Xcode 命令行工具（没有的话先在终端运行 `xcode-select --install`）。

```bash
git clone https://github.com/celestewynne0506-pixel/ai-boot-animations.git
cd ai-boot-animations/claude
./install.sh
```

装好后菜单栏右边（电池左边）会出现 ✨ 图标，并弹出设置窗口。下次打开 Claude 就会播放；想马上看效果，点 ✨ →「播放一次开屏动画」。

本地编译安装，不需要下载来路不明的 App，也不需要辅助功能、屏幕录制等任何系统授权。

## 菜单栏 ✨ 能干什么

装好后菜单栏右边（电池左边）会常驻一个小星星 ✨，点开就能调。所有调节**拖动时立刻生效**，正在播放的动画马上跟着变，不用重启 Claude。

<p align="center">
  <img src="docs/menu.png" width="300" alt="菜单栏 ✨ 菜单">
  &nbsp;&nbsp;
  <img src="docs/settings.png" width="330" alt="设置窗口">
</p>

**打开 Claude 时**放什么，两个开关自由组合：

| 播放开屏动画 | 保留循环背景 | 效果 |
|:---:|:---:|---|
| ✅ | ✅ | 默认：先放开屏，再透出界面，留下半透明动态背景，直到你手动关掉 |
| ✅ | ❌ | 只放开屏，透出界面时整个淡出消失 |
| ❌ | ✅ | 不放开屏，Claude 一打开就直接有动态背景 |
| ❌ | ❌ | 原装启动，什么都不放 |

**三个滑块：**

- **背景不透明度**（0–80%）：循环背景有多浓。调低更不挡字，调高更有氛围。默认 25%
- **开屏音量**：开屏音效（拔剑、闪光、烟花）的音量。电脑静音时不出声
- **循环背景音量**：循环背景环境声的音量，调到 0 就是安静的动态壁纸

**现在，在 Claude 窗口上：** 不用重启 Claude，直接在当前窗口上「播放一次开屏动画」「开启循环背景」或「关掉动画 / 背景」。循环背景就是从这里关的。

**其他：**

- **跳过**：开屏时右上角有「跳过」，点了会把画面淡出、接到循环背景；进入循环背景后跳过键自动消失
- **设置窗口…**：跟菜单一样的内容，单独一个窗口。找不到 ✨ 时，在聚焦搜索（⌘ 空格）里搜 `ClaudeBootAnimation` 打开也会弹出它
- **打开设置文件…**：更细的参数，比如字幕文字、字幕时间、字幕大小，见下表
- **卸载…**：确认后一键删干净

### 设置文件

`~/Library/Application Support/ClaudeBootAnimation/config.json`，改完保存，下次播放生效：

| 键 | 默认 | 含义 |
|---|---|---|
| `playIntro` / `loopBackground` | true / true | 同菜单里的两个开关 |
| `residualAlpha` | 0.25 | 循环背景不透明度 |
| `introVolume` / `loopVolume` | 1.0 / 0.5 | 开屏音量 / 循环背景音量 |
| `fadeStartSeconds` | 10.767 | 开屏里进入循环画面、开始透出界面的时间 |
| `fadeDurationSeconds` | 1.2 | 透出界面的渐变时长 |
| `showSubtitles` | true | 是否显示字幕 |
| `subtitles` | 两句 | 字幕文字和起止秒数 |
| `subtitleFadeSeconds` | 0.5 | 字幕渐显渐隐时长 |
| `subtitleWidthRatio` | 0.6 | 字幕大小（第一句约占窗口宽度的比例） |

## 换成自己的动画

```bash
./build.sh 你的开屏.mp4 你的循环.mp4          # 只打包
./install.sh                                  # 打包并安装（用 assets/ 里的默认动画）
```

想装自己的动画：把两个文件替换成 `assets/intro.mp4`、`assets/loop.mp4` 再运行 `./install.sh`。要求：

- 开屏的最后一帧能接上循环的第一帧，循环首尾相接
- 推荐 H.264 或 HEVC（`hvc1` 标签），带音轨的话音轨放在开屏文件里
- 改了开屏长度，记得在设置文件里调 `fadeStartSeconds` 和字幕时间

## 卸载

菜单栏 ✨ →「卸载…」，或者：

```bash
./uninstall.sh
```

会删除小程序、登录自启、设置和日志。Claude 本身从来没被改过，卸载后就是原装的样子。

## 原理

- 小程序登录后在后台常驻（`~/Library/LaunchAgents`），监听 Claude 启动
- 用 `CGWindowListCopyWindowInfo` 只读取 Claude 主窗口的位置和大小（不读标题和内容，所以不需要授权），在它正上方盖一个无边框窗口播放动画，并跟着窗口移动、缩放，不会盖到别的 App
- 开屏和循环在内存里拼成一条约 8 小时的时间线一次播放，接缝不卡；放到头自动跳回循环开头
- 进入循环后窗口变半透明并开启点击穿透，Claude 照常使用

日志：`~/Library/Logs/ClaudeBootAnimation.log`

开发用参数：`--preview`（在当前 Claude 窗口上预览）、`--loop-only`、`--test-skip 秒`、`--repeats N`、`--render-subtitle 背景.png 输出.png 第几句`、`--show-menu`（自动弹出菜单，方便截图）。

## 授权

- 代码：[MIT](../LICENSE)
- 动画素材：[CC BY-NC-ND 4.0](assets/LICENSE.md)，可以安装、分享，不能商用、不能改后再发布。角色是网上流传的克劳德形象，画面由 Seedance 生成，分镜与动作设计由作者完成
- 音效：Freesound CC0 素材，见 [CREDITS.md](CREDITS.md)

---

**English (short):** An unofficial boot animation for the Claude desktop app on macOS. A tiny menu-bar helper overlays Claude's window with an intro animation, then fades into a translucent, click-through looping background. It never modifies Claude.app. Install with `./install.sh` (requires macOS 13+ and Xcode Command Line Tools); uninstall from the ✨ menu or with `./uninstall.sh`. Code is MIT; animation assets are CC BY-NC-ND 4.0.
