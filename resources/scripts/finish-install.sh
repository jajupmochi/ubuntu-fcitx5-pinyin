#!/usr/bin/env bash
# Appendix 12.2 — install fcitx5 + Chinese addons + Lua module + the panel font,
# switch the IM framework, set env vars and autostart.
# Calls sudo for the package step; works unchanged as root (e.g. under pkexec).
set -euo pipefail
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"
export DEBIAN_FRONTEND=noninteractive

$SUDO apt-get update
$SUDO apt-get install -y fcitx5 fcitx5-chinese-addons fcitx5-config-qt \
                         fcitx5-module-lua fonts-lxgw-wenkai

im-config -n fcitx5                              # switch IM framework (writes ~/.xinputrc)

mkdir -p ~/.config/environment.d
cat > ~/.config/environment.d/fcitx.conf <<'EOF'
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF

mkdir -p ~/.config/autostart
cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/ 2>/dev/null || true

echo "Done. Next: deploy ~/.config/fcitx5 (deploy-config.sh), then log out and back in."
