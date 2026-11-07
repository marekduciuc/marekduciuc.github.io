#!/usr/bin/env bash
# Builds the social preview images, the icons and the PDF CV with headless Chrome.
# Run from the repository root:  tools/build-assets.sh
# Needs: Google Chrome, python3 (local server), sips (macOS, for icon sizes).
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
PORT="${PORT:-8765}"
BASE="http://localhost:$PORT"

started=""
if ! curl -s -o /dev/null "$BASE/"; then
  python3 -m http.server "$PORT" >/dev/null 2>&1 &
  started=$!
  sleep 1
fi
cleanup() { [ -n "$started" ] && kill "$started" 2>/dev/null || true; }
trap cleanup EXIT

urlenc() { python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$1"; }

shot() { # shot <out.png> <width> <height> <query>
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --blink-settings=preferredColorScheme=1 --virtual-time-budget=3000 \
    --window-size="$2,$3" --screenshot="$1" "$BASE/tools/card.html?$4" 2>/dev/null
}

card() { # card <name> <kind> <kicker> <title> [sub]
  local q="kind=$2&kicker=$(urlenc "$3")&title=$(urlenc "$4")"
  [ -n "${5:-}" ] && q="$q&sub=$(urlenc "$5")"
  shot "assets/og/$1.png" 1200 630 "$q"
  echo "assets/og/$1.png"
}

card cv cv "" "Marek Duciuc" "I put AI into e-commerce and logistics operations – in daily use by the team, measured against KPIs."
card case-studies case "Marek Duciuc" "Case studies" "AI put into daily use – in operations, support and software delivery."
card doocan case "Case study" "AI in the daily operations of an e-commerce fulfilment centre"
card tdd-flow case "Case study" "Disciplined agentic development: from requirement to pull request with AI agents"
card support-automation case "Case study" "An AI assistant for support tickets and integrations, safe by design"
card elasticsearch case "Case study" "Elasticsearch in production: fast, stable and trusted with a bank's logs"
card manual-translator case "Case study" "From a paper manual to a Czech document: AI only where it is needed"

shot assets/icons/icon-512.png 512 512 "kind=icon"
sips -z 192 192 assets/icons/icon-512.png --out assets/icons/icon-192.png >/dev/null
sips -z 180 180 assets/icons/icon-512.png --out assets/icons/apple-touch-icon.png >/dev/null
sips -z 32 32 assets/icons/icon-512.png --out assets/icons/favicon-32.png >/dev/null
echo "assets/icons/*.png"

"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=3000 \
  --print-to-pdf=assets/Marek-Duciuc-CV.pdf "$BASE/?pdf" 2>/dev/null
echo "assets/Marek-Duciuc-CV.pdf"
