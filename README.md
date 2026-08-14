# ImmortalWrt RAX3000M NAND 自动编译固件

[![Build Status](https://github.com/HubQyz/ImmortalWrt-RAX3000M/actions/workflows/build.yml/badge.svg)](https://github.com/HubQyz/ImmortalWrt-RAX3000M/actions)
[![Release](https://img.shields.io/github/v/release/HubQyz/ImmortalWrt-RAX3000M?include_prereleases)](https://github.com/HubQyz/ImmortalWrt-RAX3000M/releases)
[![Platform](https://img.shields.io/badge/Platform-MediaTek%20Filogic-blue)](https://github.com/immortalwrt/immortalwrt)

基于 **ImmortalWrt** (OpenWrt 分支) 源码，专为 **CMCC RAX3000M (NAND版)** 路由器打造的自动化云编译固件。

本项目利用 GitHub Actions 自动拉取最新源码进行编译，集成常用插件与优化配置，旨在提供稳定、高效且功能丰富的路由系统。

## 📥 固件下载

请前往 [Releases](https://github.com/HubQyz/ImmortalWrt-RAX3000M/releases) 页面下载最新固件。

*   **sysupgrade.itb**: 用于在 U-Boot 或 OpenWrt 系统中升级（推荐）。
*   **initramfs-recovery.itb**: 用于首次刷机或救砖（通过 U-Boot Web 恢复模式刷入）。
*   **bl2.img / fip.bin**: 配套的 U-Boot 引导文件（来自 Yuzhii 适配版）。

## 🚀 固件特性

*   **核心版本**: 基于 ImmortalWrt `v25.12.1` (官方稳定版分支)。
*   **内核版本**: Linux Kernel 6.12 LTS (长期支持)。
*   **包管理器**: 使用新一代 `apk` (Alpine Package Keeper) 替代传统的 opkg。
*   **无线驱动**: 采用开源 `mt76` 驱动，持续更新优化。
*   **主题界面**: 默认集成 **Kucat (酷猫)** 主题，美观且移动端适配良好。
*   **网络优化**: 默认开启 IPv6、DNS 加速 (MosDNS + SmartDNS)、流量分载等优化。

## 🧩 内置插件清单 (基于 Build #39 日志)

本固件精简了不必要的组件，仅保留最实用的功能：

### 🛡 网络与代理
*   **Passwall2**: 强大的科学上网工具 (包含 Sing-Box, Xray, Haproxy 等核心)。
*   **SmartDNS**: 防 DNS 劫持，提升解析速度。
*   **MosDNS**: 本地 DNS 服务器，分流国内外域名 (v5 版本)。
*   **SQM**: 流量队列管理，解决游戏/视频卡顿 (Bufferbloat)。
*   **Zerotier**: 虚拟局域网组建工具。

### 🛠 系统与管理
*   **iStore**: 图形化应用商店，方便安装其他软件。
*   **Bandix**: 带宽监控与限制插件。
*   **Taskplan**: 任务计划管理。
*   **Netwizard**: 设置向导。
*   **TTYD**: 网页终端，无需 SSH 客户端即可管理后台。
*   **Autoreboot**: 自动重启计划。
*   **Lucky**: 多功能工具箱 (IPv6 DDNS, 端口转发, WakeOnLan 等)。
*   **DDNSTO**: 内网穿透与远程访问服务。
*   **WeChatPush**: 微信推送设备状态。

### 📂 存储与共享
*   **Ksmbd**: 高性能内核级 Samba 服务器 (比 Samba4 更省资源)。
*   **HD-Idle**: 硬盘休眠管理。
*   **Partexp**: 分区扩容工具。

### 🎨 主题
*   **Kucat**: 酷猫主题 (默认)。
*   **Bootstrap**: 原生主题。

> **注意**: 本固件已移除 DiskMan, DDNS-GO, Rclone 等非必要插件以保持精简。如需使用，可通过 iStore 或 apk 命令自行安装。

## ⚡ 刷机教程

> **⚠️ 警告**: 刷机有风险，操作需谨慎。请务必先备份重要数据。

### 1. 准备工作
*   下载 Releases 中的 `initramfs-recovery.itb` 和 `sysupgrade.itb`。
*   下载仓库中的 `uboot-yuzhii/bl2.img` 和 `uboot-yuzhii/fip.bin` (如果尚未刷入第三方 U-Boot)。

### 2. 首次刷机 (从原厂固件)
1.  **刷入 U-Boot**: 参考 [hanwckf/bl-mt798x](https://github.com/hanwckf/bl-mt798x) 或 Yuzhii 的教程，通过串口或原厂漏洞刷入第三方 U-Boot。
2.  **进入恢复模式**: 按住 Reset 键通电，直到指示灯闪烁，进入 U-Boot Web 恢复模式 (通常是 192.168.1.1)。
3.  **刷入过渡固件**: 在 Web 页面上传 `initramfs-recovery.itb` 并启动。
4.  **刷入正式固件**: 进入 OpenWrt 后台 (192.168.6.1)，在“系统” -> “备份/升级”中上传 `sysupgrade.itb` 进行刷机。**注意：首次刷机建议不保留配置。**

### 3. 后续升级
*   直接在 OpenWrt 后台上传新的 `sysupgrade.itb` 即可。

## ⚙️ 默认配置

*   **LAN IP**: `192.168.6.1`
*   **用户名**: `root`
*   **密码**: *无* (首次登录请设置密码)
*   **Wi-Fi 名称**: 刷机后自行查看
*   **Wi-Fi 密码**: 刷机后自行查看

## 🛠 自行编译

本项目完全开源，您可以 Fork 本仓库并使用 GitHub Actions 自行编译：

1.  Fork 本仓库。
2.  进入 `Actions` 标签页。
3.  选择 `Build ImmortalWrt RAX3000M NAND` 工作流。
4.  点击 `Run workflow`，勾选 `发布到 Release` (可选)。
5.  等待编译完成 (约 1-2 小时)，在 Releases 页面下载您自己的固件。

## 🙏 致谢

*   [ImmortalWrt](https://github.com/immortalwrt/immortalwrt): 优秀的 OpenWrt 分支。
*   [hanwckf](https://github.com/hanwckf): 提供 MT798x 系列 U-Boot 及适配支持。
*   [Yuzhii0718](https://github.com/Yuzhii0718): 提供优化的 U-Boot 版本。
*   [sirpdboy](https://github.com/sirpdboy): 提供 Kucat 主题及多款实用插件。
*   [sbwml](https://github.com/sbwml): 提供 MosDNS 插件维护。

## 📄 许可证

本项目遵循 [MIT License](LICENSE)。固件中包含的第三方软件遵循其各自的开源协议。

---
**Star History**

如果这个固件对您有帮助，请给个 Star ⭐ 支持一下！
