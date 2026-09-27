#!/usr/bin/env bash
# Print the name of an available iPhone simulator on the newest iOS runtime,
# for use in: -destination "platform=iOS Simulator,name=<name>".
# Usage: pick-simulator.sh [timeout-seconds]   (default 20)
# Exit codes: 0 found, 1 simctl failed or no iPhone, 2 simctl timed out.
set -euo pipefail

timeout_s="${1:-20}"
out="$(mktemp)"
trap 'rm -f "$out"' EXIT

xcrun simctl list devices available >"$out" 2>&1 &
pid=$!
for ((i = 0; i < timeout_s; i++)); do
  kill -0 "$pid" 2>/dev/null || break
  sleep 1
done
if kill -0 "$pid" 2>/dev/null; then
  kill "$pid" 2>/dev/null || true
  echo "simctl did not respond within ${timeout_s}s; CoreSimulatorService is probably hung." >&2
  echo "Recover: quit Simulator, then: killall -9 com.apple.CoreSimulator.CoreSimulatorService" >&2
  exit 2
fi
if ! wait "$pid"; then
  cat "$out" >&2
  exit 1
fi

# Sections look like "-- iOS 26.4 --"; the newest runtime is listed last.
name="$(awk '
  /^-- iOS / { in_ios = 1; first = ""; next }
  /^-- /     { in_ios = 0; next }
  in_ios && first == "" && /iPhone/ {
    line = $0
    sub(/^[ \t]+/, "", line)
    sub(/ \([0-9A-F-]+\).*$/, "", line)
    first = line; newest = line
  }
  END { print newest }
' "$out")"

if [[ -z "$name" ]]; then
  echo "No available iPhone simulator. Install one in Xcode > Settings > Components." >&2
  exit 1
fi
echo "$name"
