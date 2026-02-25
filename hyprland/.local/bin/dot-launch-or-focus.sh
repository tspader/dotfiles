#!/bin/bash
set -euo pipefail

if (($# < 2)); then
  exit 1
fi

pattern="$1"
shift

address="$(hyprctl clients -j | jq -r --arg p "$pattern" '.[] | select((.class // "" | test($p; "i")) or (.title // "" | test($p; "i"))) | .address' | head -n1)"

if [[ -n "$address" ]]; then
  hyprctl dispatch focuswindow "address:$address"
else
  setsid "$@" >/dev/null 2>&1 &
fi
