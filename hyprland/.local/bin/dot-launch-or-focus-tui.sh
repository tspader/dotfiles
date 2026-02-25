#!/bin/bash
set -euo pipefail

if (($# < 1)); then
  exit 1
fi

app="$(basename "$1")"
exec "$HOME/.local/bin/dot-launch-or-focus.sh" "waybar-$app" "$HOME/.local/bin/dot-launch-tui.sh" "$@"
