## Xmark-Tools v2.7.1

### 本次更新(v2.7.1)

- **新增「云端公告」**
  WebUI 打开时会先去拉 `raw.githubusercontent.com/kusesad-1122/Xmark-Tools/main/notice.txt`,失败自动兜底本地 `notice.txt`。以后改公告只要更新 `main` 分支的文件即可,不用发版。「关于」页新增「查看公告」按钮可随时重看。
- **静态 `notice.txt` 同步刷新到 v2.7 文案**
  之前的包里还留着 v2.5 说明。
- **发布流水线内部整理**
  去掉了首发用的 `claude/v2.7-*` 分支触发通道,以后正常发版走 tag push / workflow_dispatch。release notes 改为读 `.github/RELEASE_NOTES.md`,以后改公告不用动 workflow。

### 继承自 v2.7 的修复

- WebUI 部分开关点亮后视觉上自动关闭:`monitor_app.sh` 补齐 `force_hide` / `coloros_lock` 两个 key,`rkp` 读取路径改成 `rkp_done`。
- 重启后开关状态丢失:`service.sh` 的 `PERSIST_FLAGS` 扩展到含 `coloros_lock` / `coloros_signal` / `force_hide` / `notify_always` / `auto_clean` / `soter`。

### 继承自 v2.6 的修复

- 安装到最后一步 `Error code: 1 / Failed to install module script`:`customize.sh` 不再在 sourced 上下文里 `exit 0` 提前终止安装器,不再覆盖 `MODPATH`,config/flag 全部写到 `$MODPATH/config/` staging 目录,删除了尾部无用的 `am start mqqapi://`。

### 建议手动测试

- [ ] 首次打开 WebUI 应弹出公告卡片,内容与本 release 的说明一致
- [ ] 关闭再打开:同版本公告不再自动弹,「关于 → 查看公告」可强制重看
- [ ] 断网后进 WebUI:公告卡片仍能显示,右上角徽章从「云端」变「本地」
- [ ] 打开「强制开启隐藏」、「解除 ColorOS 云控锁帧」、"一键修复 RKP",3 秒后不应变灰
- [ ] 重启一次,SOTER / 常驻通知 / 自动清理等开关应保持上次设置
