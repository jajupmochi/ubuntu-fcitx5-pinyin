#!/usr/bin/env bash
# Appendix 12.7 — end-to-end check after setup (and after a Wayland relogin).
echo "session : ${XDG_SESSION_TYPE:-?}"                        # wayland (or x11)
pgrep -x fcitx5 >/dev/null && echo "fcitx5  : running" || echo "fcitx5  : NOT running"
echo "im vars : $GTK_IM_MODULE / $QT_IM_MODULE / $XMODIFIERS"  # fcitx / fcitx / @im=fcitx
gnome-extensions info kimpanel@kde.org 2>/dev/null | grep -i state   # State: ACTIVE
fcitx5-remote -n                                               # current IM (keyboard-xx / pinyin)
echo "If fcitx5-remote says 'Failed to get reply' right after start, it's still"
echo "loading dictionaries (~74MB set takes a few seconds) — wait and retry."
