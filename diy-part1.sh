#!/bin/bash
# ============================================================
# diy-part1.sh — 在 feeds 更新之前执行
# 作用：添加自定义软件源、克隆额外 package
# ============================================================

# ---------- 移除 feeds.conf 里可能存在的 sirpdboy lucky ----------
sed -i '/luci-app-lucky/d' feeds.conf.default
sed -i '/sirpdboy.*lucky/d' feeds.conf.default

# ---------- 克隆 gdy666 官方 lucky 到 package 目录 ----------
# gdy666 的仓库包含两个子包：lucky（主程序）和 luci-app-lucky（LuCI界面）
# clone 到 package/lucky 后，编译系统会自动识别
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

echo ">>> diy-part1.sh done: gdy666 lucky source added."
