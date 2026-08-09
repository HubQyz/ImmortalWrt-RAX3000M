#!/bin/bash
# ============================================================
# diy-part1.sh — 在 feeds update 之前执行
# ============================================================

# ---------- 1. 删除 kenzok8 feed 自带的 sirpdboy lucky ----------
# kenzok8/openwrt-packages 里有 luci-app-lucky (sirpdboy版)
# 它的 init 脚本不兼容 ImmortalWrt 25.12 procd，必须移除
rm -rf package/feeds/kenzok8/luci-app-lucky
rm -rf package/feeds/kenzok8/lucky
rm -rf package/feeds/small/luci-app-lucky
rm -rf package/feeds/small/lucky

# 同时从 feeds.conf.default 里注释掉可能的重复源
sed -i '/src-git.*lucky/d' feeds.conf.default

echo ">>> Removed sirpdboy lucky from kenzok8 feeds."

# ---------- 2. 克隆 gdy666 官方 lucky ----------
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

echo ">>> Cloned gdy666/luci-app-lucky to package/lucky/"
echo ">>> diy-part1.sh done."
