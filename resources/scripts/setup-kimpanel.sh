#!/usr/bin/env bash
# Appendix 12.4 — install the Kimpanel GNOME extension headlessly, overlay this
# repo's panel.js/stylesheet.css + dog frames, set the font, arm auto-enable.
# User-level (no root). Log out and back in afterwards.
set -euo pipefail
U5="${U5:-/tmp/u5}"
[ -d "$U5/resources/kimpanel" ] || git clone --depth 1 https://github.com/jajupmochi/ubuntu-fcitx5-pinyin "$U5"

EXT=~/.local/share/gnome-shell/extensions/kimpanel@kde.org
VER=$(gnome-shell --version | grep -oE '[0-9]+' | head -1)
url=$(curl -sL "https://extensions.gnome.org/extension-info/?uuid=kimpanel@kde.org&shell_version=$VER" \
      | python3 -c 'import sys,json;print("https://extensions.gnome.org"+json.load(sys.stdin)["download_url"])')
curl -sL "$url" -o /tmp/kimpanel.zip && gnome-extensions install --force /tmp/kimpanel.zip

cp "$U5"/resources/kimpanel/panel.js       "$EXT/panel.js"
cp "$U5"/resources/kimpanel/stylesheet.css "$EXT/stylesheet.css"
mkdir -p "$EXT/dog"; cp "$U5"/resources/kimpanel/dog/d?.png "$EXT/dog/"

gsettings set org.gnome.shell disable-user-extensions false
gsettings --schemadir "$EXT/schemas" set org.gnome.shell.extensions.kimpanel font 'LXGW WenKai 14'

# arm it to auto-enable on next login (the running shell can't see a fresh extension)
python3 - <<'PY'
import subprocess, ast
k, key = 'org.gnome.shell', 'enabled-extensions'
cur = ast.literal_eval(subprocess.check_output(['gsettings','get',k,key]).decode())
if 'kimpanel@kde.org' not in cur: cur.append('kimpanel@kde.org')
subprocess.run(['gsettings','set',k,key,'['+', '.join("'%s'"%x for x in cur)+']'])
PY

echo "Kimpanel installed + themed. LOG OUT and back in to load it."
