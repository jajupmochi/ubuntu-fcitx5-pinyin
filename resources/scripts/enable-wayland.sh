#!/usr/bin/env bash
# Appendix 12.6 — re-enable Wayland in GDM (if you were forced onto Xorg).
# Needs root. After this: reboot, then pick "Ubuntu" (Wayland) at the greeter.
set -euo pipefail
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"
$SUDO cp -n /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
$SUDO sed -i 's/^WaylandEnable=false/#WaylandEnable=false/' /etc/gdm3/custom.conf
echo "Wayland enabled in GDM (backup: /etc/gdm3/custom.conf.bak)."
echo "Reboot, then at the login screen pick the gear -> 'Ubuntu' (Wayland)."
echo "Revert: sudo cp /etc/gdm3/custom.conf.bak /etc/gdm3/custom.conf"
