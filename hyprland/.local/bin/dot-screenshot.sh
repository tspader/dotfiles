#!/bin/bash
set -euo pipefail

mode="${1:-region}"
dir="$HOME/media/images/screenshots"
mkdir -p "$dir"
file="$dir/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

case "$mode" in
  region)
    geom="$(slurp -d)"
    grim -g "$geom" "$file"
    ;;
  workspace)
    output="$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | .name' | head -n1)"
    grim -o "$output" "$file"
    ;;
  window)
    win="$(hyprctl -j activewindow)"
    x="$(printf "%s" "$win" | jq -r '.at[0]')"
    y="$(printf "%s" "$win" | jq -r '.at[1]')"
    w="$(printf "%s" "$win" | jq -r '.size[0]')"
    h="$(printf "%s" "$win" | jq -r '.size[1]')"
    grim -g "${x},${y} ${w}x${h}" "$file"
    ;;
  *)
    exit 1
    ;;
esac

wl-copy < "$file"
