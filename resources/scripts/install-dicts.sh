#!/usr/bin/env bash
# Appendix 12.5 — install ready-made dictionaries (zhwiki + 肥猫) and batch-import
# a curated set of Sogou cell dictionaries. User-level (no root).
# Sogou's new "ECS" official dicts can't be converted, so they're skipped automatically.
set -euo pipefail
D=~/.local/share/fcitx5/pinyin/dictionaries; mkdir -p "$D"
T=/tmp/sg; mkdir -p "$T"; : > "$T/all.txt"

# --- ready-made .dict ---
curl -L -o "$D/zhwiki.dict" "$(curl -s https://api.github.com/repos/felixonmars/fcitx5-pinyin-zhwiki/releases/latest \
   | grep -oE 'https://[^"]*zhwiki-[0-9]+\.dict' | head -1)"
curl -L -o "$D/feimao.dict" \
   https://github.com/wuhgit/CustomPinyinDictionary/releases/download/assets/CustomPinyinDictionary_Fcitx.dict

# --- Sogou cell dicts: curated ids (IT/AI/math/phys/chem/bio/med/place) ---
for id in 4070 31696 79782 72476 54015 403 6239 2664 1216 15202 8162 15203 165 15205 148 15124 1375 12825 15125 1596; do
  curl -sL "https://pinyin.sogou.com/d/dict/download_cell.php?id=$id&name=d$id" -o "$T/$id.scel"
  if [ "$(xxd -s4 -l1 "$T/$id.scel" | awk '{print $2}')" != "44" ]; then
    echo "skip $id (new ECS format, not convertible)"; continue
  fi
  scel2org5 -o "$T/$id.txt" "$T/$id.scel" 2>/dev/null && grep -P '\t' "$T/$id.txt" >> "$T/all.txt"
done
sort -u "$T/all.txt" > "$T/merged.txt"
libime_pinyindict "$T/merged.txt" "$D/sogou.dict"
fcitx5 -r
echo "Dictionaries installed in $D"
