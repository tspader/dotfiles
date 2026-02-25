#!/bin/bash
set -euo pipefail

rfkill unblock wifi >/dev/null 2>&1 || true

if command -v impala >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus-tui.sh" impala
fi

if command -v nm-connection-editor >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus.sh" "nm-connection-editor" nm-connection-editor
fi

if command -v nmtui >/dev/null 2>&1; then
  exec "$HOME/.local/bin/dot-launch-or-focus-tui.sh" nmtui
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "No Wi-Fi tool found" "Install impala, nm-connection-editor, or nmtui"
fi
