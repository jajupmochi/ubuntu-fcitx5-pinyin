#!/usr/bin/env bash
# Appendix 12.3 — deploy the fcitx5 engine config from this repo. User-level (no root).
# Set LAYOUT to match your physical keyboard (the repo profile is hardcoded to "us").
set -euo pipefail
U5="${U5:-/tmp/u5}"
[ -d "$U5/resources/fcitx5" ] || git clone --depth 1 https://github.com/jajupmochi/ubuntu-fcitx5-pinyin "$U5"

pkill -x fcitx5 || true; sleep 1                  # 5.1: stop before editing
mkdir -p ~/.config/fcitx5/conf \
         ~/.local/share/fcitx5/lua/imeapi/extensions \
         ~/.local/share/fcitx5/data/quickphrase.d
cp "$U5"/resources/fcitx5/profile               ~/.config/fcitx5/profile
cp "$U5"/resources/fcitx5/config                ~/.config/fcitx5/config
cp "$U5"/resources/fcitx5/conf/*.conf           ~/.config/fcitx5/conf/
cp "$U5"/resources/fcitx5/lua/custom.lua        ~/.local/share/fcitx5/lua/imeapi/extensions/
cp "$U5"/resources/fcitx5/quickphrase/custom.mb ~/.local/share/fcitx5/data/quickphrase.d/

# ⚠️ keyboard layout — find yours with: localectl status  → X11 Layout
LAYOUT="${LAYOUT:-fr}"
sed -i "s/^Default Layout=.*/Default Layout=$LAYOUT/" ~/.config/fcitx5/profile
sed -i "s/^Name=keyboard-.*/Name=keyboard-$LAYOUT/"   ~/.config/fcitx5/profile
gsettings set org.gnome.desktop.input-sources sources "[('xkb','$LAYOUT')]"

setsid fcitx5 -d </dev/null &>/dev/null &         # relaunch
echo "Config deployed (layout=$LAYOUT). Re-run with LAYOUT=<xkb> if that's wrong."
