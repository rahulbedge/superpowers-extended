# Fork Marketplace Setup — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure the forked superpowers repo so it can be registered as a Claude Code marketplace (`rahul-claude-plugins`) and installed as the `superpowers-extended` plugin.

**Architecture:** Single-repo approach — the fork serves as both marketplace catalog and plugin content. The marketplace entry in `.claude-plugin/marketplace.json` points to `source: "./"` so the same repo is the plugin payload.

**Tech Stack:** JSON config files, bash script

---

### Task 1: Update marketplace.json

**Files:**
- Modify: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Rewrite marketplace.json with new identity**

Replace the entire content of `.claude-plugin/marketplace.json`:

```json
{
  "name": "rahul-claude-plugins",
  "description": "Superpowers extended with additional skill-level guardrails and extensions",
  "owner": {
    "name": "Rahul Bedge",
    "email": "rahul@bedge.in"
  },
  "plugins": [
    {
      "name": "superpowers-extended",
      "description": "Superpowers core skills library extended with additional guardrails and skill extensions",
      "version": "5.1.0.1",
      "source": "./",
      "author": {
        "name": "Rahul Bedge",
        "email": "rahul@bedge.in"
      }
    }
  ]
}
```

- [ ] **Step 2: Commit**

```bash
git add .claude-plugin/marketplace.json
git commit -m "feat: rebrand marketplace as rahul-claude-plugins with superpowers-extended plugin"
```

---

### Task 2: Update plugin.json

**Files:**
- Modify: `.claude-plugin/plugin.json`

- [ ] **Step 1: Rewrite plugin.json with new identity**

Replace the entire content of `.claude-plugin/plugin.json`:

```json
{
  "name": "superpowers-extended",
  "description": "Superpowers core skills library extended with additional guardrails and skill extensions",
  "version": "5.1.0.1",
  "author": {
    "name": "Rahul Bedge",
    "email": "rahul@bedge.in"
  },
  "homepage": "https://github.com/rahulbedge/superpowers-extended",
  "repository": "https://github.com/rahulbedge/superpowers-extended",
  "license": "MIT",
  "keywords": [
    "skills",
    "tdd",
    "debugging",
    "collaboration",
    "best-practices",
    "workflows",
    "guardrails",
    "extensions"
  ]
}
```

- [ ] **Step 2: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "feat: rebrand plugin as superpowers-extended v5.1.0.1"
```

---

### Task 3: Update sync-to-installed.sh cache path

**Files:**
- Modify: `scripts/sync-to-installed.sh`

- [ ] **Step 1: Update the PLUGIN_CACHE variable**

Change line 9 from:
```bash
PLUGIN_CACHE="${HOME}/.claude/plugins/cache/claude-plugins-official/superpowers"
```
To:
```bash
PLUGIN_CACHE="${HOME}/.claude/plugins/cache/rahul-claude-plugins/superpowers-extended"
```

- [ ] **Step 2: Commit**

```bash
git add scripts/sync-to-installed.sh
git commit -m "feat: update sync script cache path for superpowers-extended"
```

---

### Task 4: Register marketplace and install

**Files:**
- Modify: `~/.claude/settings.json`

- [ ] **Step 1: Add marketplace to extraKnownMarketplaces**

Run this to add the marketplace entry:

```bash
claude config add extraKnownMarketplaces.rahul-claude-plugins '{"source": {"source": "github", "repo": "rahulbedge/superpowers-extended"}}'
```

Or manually add to `~/.claude/settings.json` under `extraKnownMarketplaces`:

```json
"rahul-claude-plugins": {
  "source": {
    "source": "github",
    "repo": "rahulbedge/superpowers-extended"
  }
}
```

- [ ] **Step 2: Install the plugin from your marketplace**

```bash
claude /plugin install superpowers-extended@rahul-claude-plugins
```

- [ ] **Step 3: Verify installation**

Run and check the output shows `rahul-claude-plugins` and `superpowers-extended`:

```bash
ls ~/.claude/plugins/cache/rahul-claude-plugins/superpowers-extended/
```

---

### Post-Implementation: Dev workflow

**Fast local iteration:**
```bash
./scripts/sync-to-installed.sh    # syncs changes to cache
# then in Claude Code: /reload-plugins
```

**Full update from GitHub:**
```bash
claude /plugin update superpowers-extended@rahul-claude-plugins
# then in Claude Code: /reload-plugins
```
