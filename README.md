# ImmortalWrt RAX3000M NAND · 官方 25.12 稳定版 · 自动编译固件

[![Workflow](https://github.com/HubQyz/ImmortalWrt-RAX3000M/actions/workflows/build.yml/badge.svg)](https://github.com/HubQyz/ImmortalWrt-RAX3000M/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/HubQyz/ImmortalWrt-RAX3000M)](https://github.com/HubQyz/ImmortalWrt-RAX3000M/releases)

> 基于 ImmortalWrt 官方 **v25.12.1 稳定版**源码，面向 **CMCC RAX3000M（MT7981 / NAND 128M）** 的定制固件。
> 每天自动检测上游更新：**有更新才编译，无更新跳过**，编译完成自动发布 Release。

- 📥 **固件下载**：[Releases](https://github.com/HubQyz/ImmortalWrt-RAX3000M/releases)
- 🧬 内核：Linux 6.12 LTS ｜ 无线驱动：mt76 开源驱动 ｜ 包管理器：apk
- 📦 固件格式：`.itb`（FIT image）｜ 平台：mediatek/filogic

---

## ✨ 特性一览

- ✅ 官方 25.12 稳定版源码，非 SNAPSHOT，长期维护
- ✅ KUCAT 酷猫主题（移动端优化）+ 中文界面
- ✅ 科学上网：HomeProxy（官方自带，Sing-box 核心）
- ✅ DNS 双重优化：MosDNS v5（sbwml）+ SmartDNS
- ✅ 广告拦截：AdBlock-Fast + GNU 加速工具包（gawk/grep/sed/sort）
- ✅ 局域网共享：Ksmbd（内核态 SMB，高性能低占用，替代 Samba4）
- ✅ 实用工具集：Lucky / ZeroTier / DDNSTO / NetWizard / iStore / 微信推送 / 磁盘扩容 / 硬盘休眠 / SQM+EqosPlus 限速 / Bandix 实时带宽监控

---

## 📦 内置插件清单

| 分类 | 插件 |
|---|---|
| 科学上网 | HomeProxy |
| 广告拦截 | AdBlock-Fast（含 LuCI + 中文） |
| DNS 优化 | MosDNS v5（含 v2dat / geoip / geosite）、SmartDNS |
| 局域网共享 | Ksmbd（kmod + server + LuCI） |
| 主题美化 | KUCAT 酷猫 + 主题设置插件 |
| 远程访问 | DDNSTO 蒲公英旁路由组网、ZeroTier、Lucky（端口转发/DDNS/内网穿透） |
| 磁盘管理 | PartExp 磁盘扩容、hd-idle 硬盘休眠 |
| 系统工具 | NetWizard 设置向导、TaskPlan 定时任务、AutoReboot 定时重启、ttyd 终端、WeChatPush 微信推送 |
| 监控统计 | vnStat2 流量统计、Bandix 实时带宽 |
| 限速 QoS | SQM（Cake 队列）、EqosPlus |
| 应用商店 | iStore |
| 外接硬盘 | USB 存储 + ext4/exFAT/NTFS3 + block-mount + fdisk/e2fsprogs |

---

## ⚙️ 出厂默认设置

| 项目 | 默认值 |
|---|---|
| 管理地址 | `192.168.6.1` |
| 管理密码 | 无（留空） |
| 主机名 | `ImmortalWrtQi` |
| 默认主题 | KUCAT 酷猫 |
| 2.4G Wi-Fi | `Taurus`（信道 6） |
| 5G Wi-Fi | `Taurus_5G`（信道 40） |
| Wi-Fi 密码 | `77585211314` |

> 以上默认值由 [`files/etc/uci-defaults/99-custom-init`](files/etc/uci-defaults/99-custom-init) 在**首次启动时写入一次**，如需修改请编辑该文件后重新编译。

---

## 🗂 仓库结构

```
ImmortalWrt-RAX3000M/
├── .github/workflows/
│   └── build.yml                 # CI 工作流：更新检测 → 编译 → 发布 → 清理
├── .config                       # 软件包选择配置（固件定制核心）
├── files/
│   └── etc/uci-defaults/
│       └── 99-custom-init        # 首次启动初始化脚本（IP/主机名/Wi-Fi/主题）
├── uboot-yuzhii/
│   ├── bl2.img                   # U-Boot 文件（来自 Yuzhii0718/bl-mt798x-dhcpd）
│   └── fip.bin
└── README.md
```

---

## 🤖 自动编译机制

### 触发方式

| 方式 | 说明 |
|---|---|
| ⏰ 定时触发 | 每天 **北京时间 03:00**（UTC 19:00）自动运行更新检测 |
| 🖱 手动触发 | Actions → `Run workflow`，无条件完整编译 |

### 更新检测（check job）

定时触发后先计算**上游指纹**（以下仓库 SHA 拼接后的 md5），与上次发布记录在 Release 正文里的指纹比对，**任意一项变化才编译**：

- 官方源码 tag `v25.12.1`
- 官方 feeds 分支：`immortalwrt/luci`、`immortalwrt/packages`（openwrt-25.12）—— HomeProxy / Ksmbd / AdBlock-Fast 等插件的更新来源
- 13 个第三方插件仓库：mosdns(v5)、kucat 系列、bandix 系列、istore 系列等

| 上游事件 | 是否重编 |
|---|---|
| 官方 feeds 推送插件新版本 | ✅ 触发 |
| 第三方插件仓库有新提交 | ✅ 触发 |
| 官方发布新版（如 v25.12.2） | ❌ 不触发（钉死稳定版） |
| 全部无更新 | ❌ 跳过，不浪费编译时间 |
| 手动触发 | ✅ 无条件编译 |

> 指纹以隐藏注释 `<!-- FP: xxx -->` 写入 Release 正文，**仅在发布成功后更新**，天然避免"编译失败却跳过下次"的问题。

### 发布与清理

- Release 命名：`ImmortalWrt-RAX3000M-NAND-Official-25.12.1-Build-<运行编号>`
- 自动清理：**只保留最近 3 个 Release**（旧 tag 一并删除）
- Artifact 仅保留 1 天，固件以下载 Release 附件为准
- Release 说明自动生成：编译时间 / 内核版本 / 核心插件真实版本号（三层取值：包索引 → 编译产物文件名 → Makefile）

---

## 🔧 自定义指南

| 需求 | 修改位置 |
|---|---|
| 增删插件 | 编辑根目录 `.config`（`CONFIG_PACKAGE_xxx=y`），提交后下次编译生效 |
| 改 Wi-Fi 名称/密码、主机名、LAN IP | 编辑 `files/etc/uci-defaults/99-custom-init` |
| 改自动编译时间 | 编辑 `build.yml` 中 `schedule.cron` |
| 增删"更新检测"监控的仓库 | 编辑 `build.yml` check job 中的 `git ls-remote` 行 |
| 更换设备型号 | 需同步修改 `build.yml` 中 `CONFIG_TARGET_*` 三行及 U-Boot 附件 |

---

## 🚀 刷机说明

1. **U-Boot 要求**：需使用支持 `.itb` 格式的 U-Boot（如 hanwckf/bl-mt798x 20241115+）；仓库附带的 `bl2.img` / `fip.bin` 来自 [Yuzhii0718/bl-mt798x-dhcpd](https://github.com/Yuzhii0718/bl-mt798x-dhcpd)，仅供参考
2. **首次刷机**：先刷 `initramfs-recovery.itb` 过渡，再刷 `sysupgrade.itb`
3. **升级固件**：使用 `sysupgrade.itb`，**建议不保留配置**升级
4. **包管理器**：25.12 起使用 **apk**，安装软件请用 `apk add xxx`（opkg 命令已不存在）

---

## ❓ 常见问题

**Q：添加了定时任务为什么没有立刻编译？**
A：cron 是"到点触发"，不是添加后立即运行。启用后的**第一个到点时刻**（北京 03:00）必然编译一次（旧 Release 无指纹），之后才按"有更新才编"运行。

**Q：03:00 过了还没看到运行？**
A：GitHub cron 高峰期可能延迟几十分钟；另外 schedule 只对**默认分支**生效，仓库 60 天无活动会暂停定时任务（push 一次即恢复），fork 仓库默认不启用。

**Q：编译日志里 `gst1-plugins-base` 依赖警告？**
A：feeds 元数据告警，不影响编译与固件，可忽略。

**Q：Release 里某个插件版本显示 Unknown？**
A：版本取值为三层回退（包索引 → bin 产物文件名 → Makefile），若仍 Unknown 说明该包未实际编译，请检查 `.config`。

---

## ⚠️ 免责声明

本项目仅供学习交流使用，固件基于 ImmortalWrt 开源项目自动构建，不提供任何担保。
请遵守当地法律法规，合理使用网络功能。因使用本固件造成的任何损失，作者不承担责任。

---

**鸣谢**：[ImmortalWrt](https://github.com/immortalwrt/immortalwrt) ・ [sbwml/luci-app-mosdns](https://github.com/sbwml/luci-app-mosdns) ・ [sirpdboy](https://github.com/sirpdboy) ・ [linkease](https://github.com/linkease) ・ [hanwckf/bl-mt798x](https://github.com/hanwckf/bl-mt798x)
