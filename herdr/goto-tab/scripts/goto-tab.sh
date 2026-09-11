#!/bin/sh
# goto-tab.sh <1-based-index>
# Focuses the Nth tab (left-to-right) in the active workspace.
# Invoked by herdr as a plugin action; herdr provides HERDR_* env vars
# when they're available.
set -eu

n="${1:?usage: goto-tab.sh <index>}"

if ! command -v jq >/dev/null 2>&1; then
  echo "goto-tab: jq is required but not found on PATH" >&2
  exit 1
fi

ws="${HERDR_ACTIVE_WORKSPACE_ID:-${HERDR_WORKSPACE_ID:-}}"

if [ -n "$ws" ]; then
  list_json=$(herdr tab list --workspace "$ws" --json 2>/dev/null || herdr tab list --workspace "$ws")
else
  # No workspace id in the environment; fall back to whatever
  # `tab list` treats as the active workspace.
  list_json=$(herdr tab list --json 2>/dev/null || herdr tab list)
fi

id=$(printf '%s' "$list_json" | jq -r --argjson n "$n" '.result.tabs[$n-1].tab_id // empty')

if [ -z "$id" ]; then
  echo "goto-tab: no tab at position $n" >&2
  exit 1
fi

herdr tab focus "$id"
