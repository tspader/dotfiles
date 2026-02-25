#!/bin/bash
set -euo pipefail

rfkill unblock bluetooth >/dev/null 2>&1 || true

if command -v bluetui >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus-tui.sh" bluetui
fi

if command -v blueman-manager >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus.sh" "blueman-manager" blueman-manager
fi

if command -v bluetoothctl >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus-tui.sh" bluetoothctl
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "No Bluetooth tool found" "Install bluetui or blueman"
fi
