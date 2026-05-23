# Fork Marketplace Setup — Design

## Goal

Configure the forked superpowers repo so it can be registered as a Claude Code marketplace and installed as the `superpowers-extended` plugin.

## Marketplace architecture

Single-repo approach: one GitHub repo serves as both the marketplace catalog and the plugin content.

```
rahul-claude-plugins (marketplace name)
└── superpowers-extended (plugin, source: "./")
```

Claude Code discovers the marketplace via `extraKnownMarketplaces` in `~/.claude/settings.json`, reads `.claude-plugin/marketplace.json`, finds the plugin entry with `source: "./"`, and caches the repo at `~/.claude/plugins/cache/rahul-claude-plugins/superpowers-extended/<version>/`.

## Versioning

Upstream version + fork iteration suffix:

```
upstream: 5.1.0  →  fork: 5.1.0.1
upstream: 5.2.0  →  fork: 5.2.0.1  (reset .xx when rebasing on new upstream)
```

The `.xx` component tracks the fork owner's changes on top of a given upstream release.

## File changes

### 1. `.claude-plugin/marketplace.json`

Rename marketplace, update plugin entry.

### 2. `.claude-plugin/plugin.json`

Rename plugin, update repo/homepage URLs, update author.

### 3. `scripts/sync-to-installed.sh`

Update `PLUGIN_CACHE` path from `claude-plugins-official/superpowers` to `rahul-claude-plugins/superpowers-extended`.

## One-time user setup

Add to `~/.claude/settings.json` `extraKnownMarketplaces`:

```json
"rahul-claude-plugins": {
  "source": {
    "source": "github",
    "repo": "rahulbedge/superpowers-extended"
  }
}
```

Then install:

```
claude /plugin install superpowers-extended@rahul-claude-plugins
```

## Dev workflow

Two paths for testing changes:

**Local iteration (fast):** edit code → `./scripts/sync-to-installed.sh` → `/reload-plugins` in Claude Code

**Full install test:** push to GitHub → `claude /plugin update superpowers-extended@rahul-claude-plugins` → `/reload-plugins`

## What stays unchanged

- All skill files, extensions, hooks — they work as-is
- `package.json` — unused by Claude Code plugin system
- `.github/` — contributor rules unchanged
- `CLAUDE.md` — contributor guidelines unchanged

## Upstream sync

When main superpowers releases a new version, merge upstream and bump the fork version. Metadata files are the only conflict surface since skill content changes are additive (extensions directory, guardrails).
