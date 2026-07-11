## Xmark-Tools v2.7.2

### 紧急恢复(核对 v2.5 完整版)

用户反馈 v2.7 缺少「伪装 CPU 型号」选项、部分开关仍会自动关、字体缺失。定位后发现根因:public git 仓库长期是**发行包的子集**,以前每次发版都是手工打包上传的,git 里并没有维护完整的 shipped 内容。之前几次 workflow 打包只是把 git 树塞进 ZIP,导致 v2.7 的 ZIP 比 v2.5 的实际 release 缺了以下东西:

**脚本**(9 个,大部分被 commit `98d57b9` 当"死代码"清掉了)
- `scripts/cpu_spoof.sh` / `scripts/model_spoof.sh` — CPU 信息伪装真正的执行体
- `scripts/exec_daemon.sh` — `service.sh` 需要拉起的常驻执行守护
- `scripts/ptyrun.sh` / `scripts/detect.sh` / `scripts/diag.sh` / `scripts/env_audit.sh` / `scripts/hide.sh` / `scripts/extract_icons_v2.sh`

**二进制**
- `bin/ksu_reload.sh`、`bin/rcq_xt.sh`
- `bin/yuki` 大小写修正(git 里有大写 `Yuki` 但脚本引用的是小写 `yuki`)

**WebUI 资源**
- `webroot/fonts/zhiyuan.ttf`(19 MB,界面字体) — `@font-face` 声明一直在 index.html 里,只是文件没打包进去
- `webroot/donate_wx.jpg` / `webroot/donate_zfb.jpg` / `webroot/xny.jpg`
- `webroot/gg.sh` — 云端公告拉取(带 ghfast / gh-proxy 兜底代理)
- `webroot/xz.sh` / `webroot/xz_worker.sh` — 云更新触发与后台执行

**WebUI 本体**
- `webroot/index.html` 恢复到 v2.5 的 3596 行完整版(v2.7 里只剩 1900 多行,自定义冻结 / 云更新入口 / 诊断按钮 / 捐赠面板等全被砍掉了)

### 保留 v2.6 / v2.7 / v2.7.1 的修复

- **customize.sh v2.6 修复**:不再在 sourced 上下文里 `exit 0` 提前终止安装器、不再覆盖 `MODPATH`,config/flag 全部写到 `$MODPATH/config/`,移除末尾 `am start mqqapi://`。修好安装到最后一步 `Error code: 1`。
- **monitor_app.sh v2.7 修复**:补齐 `force_hide=` / `coloros_lock=` 两个 key,`rkp` 检查改成 `pid/rkp_done`。修好 WebUI 部分开关点亮后视觉上自动关。
- **service.sh v2.7 修复**:`PERSIST_FLAGS` 扩展到含 `coloros_lock` / `coloros_signal` / `force_hide` / `notify_always` / `auto_clean` / `soter`。修好重启后大部分开关变关。
- **v2.7.1 发布流水线**:`.github/workflows/release-module.yml` 从 `.github/RELEASE_NOTES.md` 读 release body,末尾自动追加 SHA256 + 构建时间。

### 建议手动测试

- [ ] 进「功能」页应看到「伪装白名单CPU型号」下方有「自定义游戏伪装」按钮,点开可勾选要伪装的游戏
- [ ] 界面文字终于用致远体渲染(而不是系统默认字)
- [ ] 首次打开 WebUI 应自动弹出公告卡片(gg.sh 走代理拉取)
- [ ] 首页应有「云更新到最新版」入口,点击后走 xz.sh 自动下载最新 release
- [ ] 强制开启隐藏 / 解除 ColorOS 云控锁帧 / 一键修复 RKP 3 个开关点亮后 3 秒不应变灰
- [ ] 重启一次,SOTER / 常驻通知 / 自动清理等开关应保持上次设置
