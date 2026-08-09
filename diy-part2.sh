#!/bin/bash
# ============================================================
# diy-part2.sh — 在 feeds install 之后执行
# ============================================================

# ========== 1. 修复 lucky init.d 脚本 (兼容 ImmortalWrt 25.12 procd) ==========
LUCKY_INIT="package/lucky/lucky/files/lucky.init"
if [ -f "$LUCKY_INIT" ]; then
    echo ">>> Patching lucky init script..."
    cat > "$LUCKY_INIT" << 'EOF'
#!/bin/sh /etc/rc.common

START=99
STOP=15
USE_PROCD=1

PROG=/usr/bin/lucky
DEFAULT_PRO_CONF='/etc/config/lucky.daji/'
PRO_CONF=$DEFAULT_PRO_CONF
CONFDIR=$PRO_CONF
UCI_CONF=/etc/config/lucky

get_config() {
    config_get_bool enabled $1 enabled 0
    config_get_bool logger $1 logger 1
    config_get PRO_CONF $1 configdir $DEFAULT_PRO_CONF
}

init_config_params() {
    config_load lucky
    config_foreach get_config
    CONFDIR=$PRO_CONF
}

init_conf_dir() {
    [ -d "$CONFDIR" ] || mkdir -p "$CONFDIR" 2>/dev/null
}

start_service() {
    if [ -s "${UCI_CONF}" ]; then
        init_config_params
        [ x$enabled = x1 ] || return 1
    fi

    init_conf_dir

    procd_open_instance lucky
    procd_set_param command "$PROG" -cd "$CONFDIR"
    procd_set_param respawn 3600 5 5
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF
    chmod +x "$LUCKY_INIT"
    echo ">>> Lucky init patched OK."
else
    echo ">>> WARNING: $LUCKY_INIT not found!"
fi

# ========== 2. 设置默认 UCI enabled=1 ==========
LUCKY_UCI="package/lucky/lucky/files/luckyuci"
if [ -f "$LUCKY_UCI" ]; then
    cat > "$LUCKY_UCI" << 'EOF'
config lucky
	option enabled '1'
	option logger '1'
	option configdir '/etc/config/lucky.daji'
EOF
    echo ">>> Lucky UCI default set to enabled=1."
fi

# ========== 3. files/ 兜底覆盖 ==========
mkdir -p files/etc/init.d
mkdir -p files/etc/config
[ -f "$LUCKY_INIT" ] && cp "$LUCKY_INIT" files/etc/init.d/lucky && chmod +x files/etc/init.d/lucky
[ -f "$LUCKY_UCI" ] && cp "$LUCKY_UCI" files/etc/config/lucky

echo ">>> diy-part2.sh done."
