#!/usr/bin/env bash
# Sync development changes from the superpowers fork to the installed plugin cache.
# Usage: ./scripts/sync-to-installed.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PLUGIN_CACHE="${HOME}/.claude/plugins/cache/rahul-claude-plugins/superpowers-extended"

# Find the latest installed version
INSTALLED_DIR=$(ls -d "${PLUGIN_CACHE}"/*/ 2>/dev/null | sort -V | tail -1)

if [ -z "$INSTALLED_DIR" ]; then
    echo "ERROR: No installed superpowers plugin found at ${PLUGIN_CACHE}" >&2
    echo "Install the plugin first with: claude /plugin superpowers" >&2
    exit 1
fi

echo "Syncing to: ${INSTALLED_DIR}"

# Copy hook scripts
for hook_script in skill-extensions session-start run-hook.cmd; do
    if [ -f "${REPO_ROOT}/hooks/${hook_script}" ]; then
        cp "${REPO_ROOT}/hooks/${hook_script}" "${INSTALLED_DIR}/hooks/"
        chmod +x "${INSTALLED_DIR}/hooks/${hook_script}"
        echo "  ✓ hooks/${hook_script}"
    fi
done

# Copy hook config
cp "${REPO_ROOT}/hooks/hooks.json" "${INSTALLED_DIR}/hooks/"
echo "  ✓ hooks/hooks.json"

# Copy extensions
rm -rf "${INSTALLED_DIR}/extensions"
cp -r "${REPO_ROOT}/extensions" "${INSTALLED_DIR}/"
echo "  ✓ extensions/ ($(find "${REPO_ROOT}/extensions" -name '*.md' | wc -l) guardrail files)"

echo ""
echo "Sync complete. Run /reload-plugins in Claude Code to activate."
