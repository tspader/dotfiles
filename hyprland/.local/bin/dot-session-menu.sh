#!/bin/bash
set -euo pipefail

choice="$(printf 'logout\ncancel\n' | walker --dmenu -p "Session" --width 240 --minheight 1 --maxheight 120 2>/dev/null || true)"

if [[ "$choice" == "logout" ]]; then
  hyprctl dispatch exit
fi
