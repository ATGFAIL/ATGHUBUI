#!/usr/bin/env bash
# Lint MainUI.lua and InterfaceManager.lua with selene and compare the result
# against baseline.txt. Findings are compared without line numbers so that
# refactors which only move code do not register as new problems.
#   ./check.sh           fail if there is any finding not in the baseline
#   ./check.sh --update  rewrite baseline.txt from the current findings
set -euo pipefail
cd "$(dirname "$0")"
current=$(selene ../../MainUI.lua ../../InterfaceManager.lua --display-style quiet 2>&1 \
	| grep -E '^\.\./\.\./' \
	| sed -E 's#^\.\./\.\./([^:]+):[0-9]+:[0-9]+: #\1: #' \
	| sort || true)
if [[ "${1:-}" == "--update" ]]; then
	printf '%s\n' "$current" > baseline.txt
	echo "baseline.txt updated ($(printf '%s\n' "$current" | grep -c . || true) findings)"
	exit 0
fi
new=$(comm -13 <(sort baseline.txt) <(printf '%s\n' "$current") | grep . || true)
fixed=$(comm -23 <(sort baseline.txt) <(printf '%s\n' "$current") | grep . || true)
if [[ -n "$fixed" ]]; then
	echo "Resolved since baseline (run ./check.sh --update to record):"
	printf '%s\n' "$fixed" | sed 's/^/  /'
fi
if [[ -n "$new" ]]; then
	echo "New selene findings:"
	printf '%s\n' "$new" | sed 's/^/  /'
	exit 1
fi
echo "selene: no new findings"
