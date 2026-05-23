# Per-Skill Guardrails Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the per-skill guardrails system into the fork so it deploys cleanly and survives plugin updates.

**Architecture:** All files already exist in the dev directory. The remaining work is: a sync script to deploy from dev → installed plugin cache, end-to-end verification, and committing everything.

**Tech Stack:** Bash

---

### Task 1: Create sync-to-installed script

**Files:**
- Create: `scripts/sync-to-installed.sh`

- [ ] **Step 1: Write the script**

```bash
#!/usr/bin/env bash
# Sync development changes from the superpowers fork to the installed plugin cache.
# Usage: ./scripts/sync-to-installed.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PLUGIN_CACHE="${HOME}/.claude/plugins/cache/claude-plugins-official/superpowers"

# Find the latest installed version
INSTALLED_DIR=$(ls -d "${PLUGIN_CACHE}"/*/ 2>/dev/null | sort -V | tail -1)

if [ -z "$INSTALLED_DIR" ]; then
    echo "ERROR: No installed superpowers plugin found at ${PLUGIN_CACHE}" >&2
    echo "Install the plugin first with: claude /plugin superpowers" >&2
    exit 1
fi

echo "Syncing to: ${INSTALLED_DIR}"

# Copy hook script
cp "${REPO_ROOT}/hooks/skill-extensions" "${INSTALLED_DIR}/hooks/"
chmod +x "${INSTALLED_DIR}/hooks/skill-extensions"
echo "  ✓ hooks/skill-extensions"

# Copy hook config
cp "${REPO_ROOT}/hooks/hooks.json" "${INSTALLED_DIR}/hooks/"
echo "  ✓ hooks/hooks.json"

# Copy extensions
rm -rf "${INSTALLED_DIR}/extensions"
cp -r "${REPO_ROOT}/extensions" "${INSTALLED_DIR}/"
echo "  ✓ extensions/ ($(find "${REPO_ROOT}/extensions" -name '*.md' | wc -l) guardrail files)"

echo ""
echo "Sync complete. Run /reload-plugins in Claude Code to activate."
```

- [ ] **Step 2: Make it executable and test dry-run**

Run: `chmod +x scripts/sync-to-installed.sh`

- [ ] **Step 3: Run sync**

Run: `./scripts/sync-to-installed.sh`
Expected: All three components synced successfully.

- [ ] **Step 4: Commit**

```bash
git add scripts/sync-to-installed.sh
git commit -m "feat: add sync-to-installed script for plugin deployment"
```

---

### Task 2: End-to-end verification

**Files:** None (verification only)

- [ ] **Step 1: Verify installed plugin has all files**

Run: `ls ~/.claude/plugins/cache/claude-plugins-official/superpowers/*/hooks/skill-extensions`
Expected: File exists.

Run: `find ~/.claude/plugins/cache/claude-plugins-official/superpowers/*/extensions -name '*.md' | wc -l`
Expected: 10

- [ ] **Step 2: Reload plugins**

Tell the user: "Run `/reload-plugins`"

- [ ] **Step 3: Smoke test hook**

Tell the user: "After reload, invoke `/superpowers:brainstorming test` and check for the guardrails injection in the system reminder."

- [ ] **Step 4: Test passthrough**

Tell the user: "Invoke `superpowers:using-git-worktrees` (no extensions dir) — should load normally, no injection."

---

### Task 3: Commit all source files

**Files:**
- `extensions/*/guardrails/guardrails.md` (10 files, already created)
- `hooks/skill-extensions` (already created)
- `hooks/hooks.json` (already modified)
- `docs/superpowers/specs/2026-05-23-per-skill-guardrails-design.md` (already created)

- [ ] **Step 1: Stage and commit**

```bash
git add extensions/ hooks/skill-extensions hooks/hooks.json docs/superpowers/specs/2026-05-23-per-skill-guardrails-design.md
git commit -m "feat: add per-skill guardrails via PreToolUse hook

Replace monolithic guardrails/CodeDiscipline.md with per-skill extension
files injected at runtime via PreToolUse hook. Each skill gets only the
disciplines actionable during its phase. Hook propagates to sub-agents
automatically.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>"
```
