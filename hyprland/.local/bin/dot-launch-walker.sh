#!/bin/bash
set -euo pipefail

if ! pgrep -x elephant >/dev/null 2>&1; then
  setsid elephant >/dev/null 2>&1 &
fi

if ! pgrep -f "walker --gapplication-service" >/dev/null 2>&1; then
  setsid walker --gapplication-service >/dev/null 2>&1 &
fi

exec walker --width 644 --maxheight 300 --minheight 300 "$@"
