#!/bin/bash
set -euo pipefail

choice="$(printf 'lock\nlogout\nsuspend\nhibernate\nreboot\nshutdown\ncancel\n' | walker --dmenu -p "Power" --width 260 --minheight 1 --maxheight 220 2>/dev/null || true)"

case "$choice" in
  lock)
    loginctl lock-session
    ;;
  logout)
    hyprctl dispatch exit
    ;;
  suspend)
    systemctl suspend
    ;;
  hibernate)
    systemctl hibernate
    ;;
  reboot)
    systemctl reboot
    ;;
  shutdown)
    systemctl poweroff
    ;;
  *)
    ;;
esac
