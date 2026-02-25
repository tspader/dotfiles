#!/bin/bash
set -euo pipefail

clients="$(hyprctl -j clients 2>/dev/null || printf '[]')"

printf "%s\n" "$clients" | jq -rc '
  map(select((.workspace.id // -1) > 0 and (.mapped // true))) as $apps
  | ($apps | length) as $count
  | if $count == 0 then
      {"text": "apps 0", "tooltip": "No open applications"}
    else
      {"text": "apps " + ($count | tostring), "tooltip": "Open applications: " + ($count | tostring)}
    end
'
