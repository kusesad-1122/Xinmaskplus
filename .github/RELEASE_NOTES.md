## Xmark-Tools v2.8.0

### 本次更新

- 优化本次清理：补齐各游戏保留项与存储/user_de 处理；
  修正 CF（仅留 shared_prefs 并改走存储）、重写无畏契约五段保留；
  新增 PUBG 四服（国际/日韩/越南/台服）；游戏列表与监控名单同步新增 PUBG 四服
- 检测环境页新增检测对抗卡：露娜/牛头驱动残留优化、春秋对抗包、Hunter 策略优化
- 功能页新增：重置防火墙、恢复实时网络、SELinux 严格/宽容切换、
  一键关闭 USB 调试、电量与充电伪装
- 改标识优化：按包 SSAID 支持自定义输入（8-16 位字母数字，失败自动从备份恢复）

### 说明

- 本次新增功能均为一次性动作，无常驻开关
- 露娜/春秋名单剔除了系统目录与正常应用数据，只删作弊/检测工具专属残留
- 终端二进制（goterm/tmux）仍需自行放入 bin/ 目录

---

## Xmark-Tools v2.7.3

### 本次更新

- 修复硬编码版本号：系统信息页的模块版本改为从 module.prop 实时读取（此前固定显示 2.3）
- 优化伪装进程：监控进程改为从 stdin 执行脚本，命令行不再暴露脚本路径；
  同时写入 /proc/self/comm 伪装内核 comm（ps/top/status Name 不再显示 sh/模块路径）
- 移除遗留的 21120 端口后台执行服务：该服务以 root 监听所有网卡且无鉴权，
  当前 WebUI 已改由 exec_daemon 常驻守护接管，无调用方，直接删除以消除风险
- 修复常驻通知每 2 秒重复发送的问题：通知只在状态变化时发送
- 修复发布包携带陈旧 pid 状态文件的问题：pid/ 目录不再打包，安装时自动清空，
  避免 yuki.pid/touch_daemon.pid 等旧文件误杀无关进程
- 修复隐藏存储数据位置：隐藏目录从模块目录迁到 /data/adb/xinmaskplus/storage_hidden，
  模块更新/卸载不再丢数据；旧数据自动迁移，卸载时自动还原
- 修复信号增强空壳 APK 问题：校验文件有效后才挂载，无效占位文件不会损坏系统应用；
  WebUI 开关会提示需要自备真实 APK
- 修复终端组件缺失体验：bin/goterm、term_kill.sh 等未随包发布时明确提示缺失而不是超时
- 发布流水线：修正不存在的 v2.6.0 回退标签为 v2.6，新增发布包不得携带 pid/ 的校验

### 说明

- goterm/tmux 等终端二进制从未进入过公开仓库，需要自行放入模块 bin/ 目录后终端功能才可用
- 伪装进程已做静态核验（mksh exec 内建支持 -a 参数替换 argv[0]，Android /system/bin/sh 即 mksh），
  实际对抗效果需真机验证

---

## Xmark-Tools v2.7.2

### 紧急恢复：核对 v2.5 完整版

用户反馈 v2.7 缺少「伪装 CPU 型号」选项、部分开关仍会自动关、字体缺失。定位后找到根因：public git 仓库长期是**发布包的子集**，以前每次发布都是手工打包上传的，git 里并没有维护完整的 shipped 内容。之前几次 workflow 打包只是把 git 树塞进 ZIP，导致 v2.7 的 ZIP 比 v2.5 的实际 release 缺了以下东西：

**脚本（9 个，大部分被 commit 98d57b9 当死代码清掉了）：**
- scripts/cpu_spoof.sh / scripts/model_spoof.sh —— CPU 信息伪装真正的执行体
- scripts/exec_daemon.sh —— service.sh 需要拉起的常驻执行守护
- scripts/ptyrun.sh / scripts/detect.sh / scripts/diag.sh / scripts/env_audit.sh / scripts/hide.sh / scripts/extract_icons_v2.sh

**二进制：**
- bin/ksu_reload.sh、bin/rcq_xt.sh
- bin/yuki 大小写修正（git 里有大写 Yuki 但脚本引用的是小写 yuki）

**WebUI 资源**
- webroot/fonts/zhiyuan.ttf（19 MB，界面字体）—— @font-face 声明一直在 index.html 里，只是文件没打包进去
- webroot/donate_wx.jpg / webroot/donate_zfb.jpg / webroot/xny.jpg
- webroot/gg.sh —— 云端公告拉取（带 ghfast / gh-proxy 兜底代理）
- webroot/xz.sh / webroot/xz_worker.sh —— 云更新触发与后台执行

**WebUI 本体**
- webroot/index.html 恢复到 v2.5 的 3596 行完整版（v2.7 里只剩 1900 多行，自定义冻结 / 云更新入口 / 诊断按钮 / 捐赠面板等全被砍了）

### 保留 v2.6 / v2.7 / v2.7.1 的修复

- customize.sh v2.6 修复：不再在 sourced 上下文里 exit 0 提前终止安装器、不再覆盖 MODPATH，config/flag 全部写到 $MODPATH/config/，移除末尾 am start mqqapi://。修好安装到最后一步 Error code: 1。
- monitor_app.sh v2.7 修复：补齐 force_hide= / coloros_lock= 两个 key，rkp 检查改成 pid/rkp_done。修好 WebUI 部分开关点亮后视觉上自动关。
- service.sh v2.7 修复：PERSIST_FLAGS 扩展到含 coloros_lock / coloros_signal / force_hide / notify_always / auto_clean / soter。修好重启后大部分开关变关。
- v2.7.1 发布流水线：.github/workflows/release-module.yml 从 .github/RELEASE_NOTES.md 读 release body，末尾自动追加 SHA256 + 构建时间。

### 建议手动测试

- [ ] 进「功能」页应看到「伪装白名单CPU型号」下方有「自定义游戏伪装」按钮，点开可勾选要伪装的游戏
- [ ] 界面文字终于用致远体渲染（而不是系统默认字）
- [ ] 首次打开 WebUI 应自动弹出公告卡片（gg.sh 走代理拉取）
- [ ] 首页应有「云更新到最新版」入口，点击后走 xz.sh 自动下载最新 release
- [ ] 强制开启隐藏 / 解除 ColorOS 云控锁帧 / 一键修复 RKP 3 个开关点亮后 3 秒不应变灭
- [ ] 重启一次，SOTER / 常驻通知 / 自动清理等开关应保持上次设置
