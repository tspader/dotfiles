#!/bin/bash
set -euo pipefail

if (($# < 1)); then
  exit 1
fi

app="$(basename "$1")"
exec alacritty --class "waybar-$app" --title "waybar-$app" -e "$@"
