#!/usr/bin/env bash
# Bump the fork iteration suffix (.xx) of the plugin version.
# Usage: ./scripts/bump-fork-version.sh
#
#  5.1.0.1 → 5.1.0.2
#  5.2.0.3 → 5.2.0.4
#
# When rebasing on a new upstream version, manually set the version in
# .claude-plugin/plugin.json and .claude-plugin/marketplace.json instead.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

PLUGIN_JSON="${REPO_ROOT}/.claude-plugin/plugin.json"
MARKETPLACE_JSON="${REPO_ROOT}/.claude-plugin/marketplace.json"

# Extract current version from plugin.json
current=$(grep -o '"version": "[^"]*"' "$PLUGIN_JSON" | head -1 | sed 's/.*"\([^"]*\)"/\1/')
base="${current%.*}"
iter="${current##*.}"

if [[ ! "$iter" =~ ^[0-9]+$ ]]; then
    echo "ERROR: version '${current}' doesn't have a numeric .xx suffix" >&2
    exit 1
fi

new="${base}.$((iter + 1))"

# Replace version in both files (preserving the rest of the line)
sed -i '' "s/\"version\": \"${current}\"/\"version\": \"${new}\"/" "$PLUGIN_JSON"
sed -i '' "s/\"version\": \"${current}\"/\"version\": \"${new}\"/" "$MARKETPLACE_JSON"

echo "Bumped ${current} → ${new}"
echo "  plugin.json"
echo "  marketplace.json"
