#!/bin/bash
set -euo pipefail

dir="${1:-next}"

active="$(hyprctl -j activeworkspace)"
current_id="$(printf "%s" "$active" | jq -r '.id')"
monitor="$(printf "%s" "$active" | jq -r '.monitor')"

mapfile -t ids < <(
  hyprctl -j workspaces |
    jq -r --arg mon "$monitor" '.[] | select(.monitor == $mon and .id > 0 and .windows > 0) | .id' |
    sort -n
)

if ((${#ids[@]} == 0)); then
  exit 0
fi

idx=-1
for i in "${!ids[@]}"; do
  if [[ "${ids[$i]}" == "$current_id" ]]; then
    idx=$i
    break
  fi
done

if ((idx < 0)); then
  ids+=("$current_id")
  IFS=$'\n' ids=($(printf "%s\n" "${ids[@]}" | sort -n))
  unset IFS
  for i in "${!ids[@]}"; do
    if [[ "${ids[$i]}" == "$current_id" ]]; then
      idx=$i
      break
    fi
  done
fi

len=${#ids[@]}
if [[ "$dir" == "prev" ]]; then
  next=$(((idx - 1 + len) % len))
else
  next=$(((idx + 1) % len))
fi

hyprctl dispatch workspace "${ids[$next]}"
