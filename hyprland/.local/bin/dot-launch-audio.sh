#!/bin/bash
set -euo pipefail

if command -v wiremix >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus-tui.sh" wiremix
fi

if command -v pavucontrol >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus.sh" "pavucontrol" pavucontrol
fi

if command -v wpctl >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus-tui.sh" wpctl status
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "No audio control tool found" "Install wiremix or pavucontrol"
fi
