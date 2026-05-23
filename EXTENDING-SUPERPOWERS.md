### How it works

When a skill is invoked via the `Skill` tool, a PreToolUse hook (`hooks/skill-extensions`) fires automatically. The hook:

1. Extracts the skill name from the tool input (e.g., `"superpowers:brainstorming"` → `"brainstorming"`)
2. Looks for `extensions/<skill-name>/` in the plugin directory
3. Reads all `.md` files recursively under that directory
4. Injects the content as additional context appended to the skill

The hook is configured in `hooks/hooks.json`:

```json
"PreToolUse": [{
  "matcher": "Skill",
  "hooks": [{
    "type": "command",
    "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" skill-extensions"
  }]
}]
```

### Directory structure

```
extensions/
├── brainstorming/
│   └── guardrails/
│       └── guardrails.md
├── test-driven-development/
│   └── guardrails/
│       └── guardrails.md
└── ...
```

The directory name must match the skill name (without the plugin namespace prefix). Any `.md` files under the skill's directory are loaded — the structure is free-form.

### Adding extensions

To add guardrails to an existing skill, create `extensions/<skill-name>/guardrails/guardrails.md`. For a new skill, create the extension directory alongside the skill:

```
skills/my-skill/SKILL.md
extensions/my-skill/guardrails/guardrails.md
```

The hook matches automatically — no configuration needed beyond creating the directory with markdown files.
