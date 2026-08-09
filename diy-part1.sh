#!/bin/bash
# ============================================================
# diy-part1.sh — 在 feeds update 之前执行
# ============================================================

# ---------- 1. 删除 kenzok8 feed 自带的 sirpdboy lucky ----------
rm -rf package/feeds/kenzok8/luci-app-lucky
rm -rf package/feeds/kenzok8/lucky
rm -rf package/feeds/small/luci-app-lucky
rm -rf package/feeds/small/lucky
sed -i '/src-git.*lucky/d' feeds.conf.default

echo ">>> Removed sirpdboy lucky from kenzok8 feeds."

# ---------- 2. 克隆 gdy666 官方 lucky ----------
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

echo ">>> Cloned gdy666/luci-app-lucky to package/lucky/"

# ---------- 3. 添加 luci-app-turboacc (网络加速) ----------
git clone https://github.com/chenmozhijin/turboacc.git package/turboacc

echo ">>> Cloned chenmozhijin/turboacc to package/turboacc/"

echo ">>> diy-part1.sh done."
