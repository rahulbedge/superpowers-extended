# Per-Skill Guardrails — Design

## Problem

`guardrails/CodeDiscipline.md` contains 12 coding disciplines derived from Andrej Karpathy's observations on LLM coding pitfalls. The disciplines are unstructured — they don't indicate which phase of the development lifecycle each rule applies to. A rule like "Surgical Changes" is critical during execution but irrelevant during brainstorming. "Do Not Complete the Narrative" is essential during design but doesn't apply during debugging.

## Design

### Approach: PreToolUse Hook + Per-Skill Extension Files

A `PreToolUse` hook intercepts `Skill` tool invocations, globs `extensions/<skill-name>/**/*.md`, and injects matching content via `additionalContext`. Each skill gets only the disciplines actionable during its phase.

### Why PreToolUse Hooks

- **Separation of concerns.** Guardrails are a cross-cutting concern. They don't belong in SKILL.md — every upstream change to a skill would risk merge conflicts.
- **Extensibility.** Adding a guardrail for a new skill is `mkdir` + a markdown file. No plumbing changes.
- **Surgical context injection.** Only the guardrails relevant to the active skill enter context.
- **Sub-agent propagation.** Hooks fire for sub-agents automatically — no special-casing needed.

### Why Not Modify SKILL.md Directly

Mixing guardrails into skills couples two concerns that evolve independently. The fork becomes a maintenance burden, and upstream skill changes risk merge conflicts on every update.

## Hook Mechanism

### hooks.json Addition

```json
"PreToolUse": [
  {
    "matcher": "Skill",
    "hooks": [
      {
        "type": "command",
        "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" skill-extensions",
        "async": false
      }
    ]
  }
]
```

### Hook Script: `hooks/skill-extensions`

Pure bash, zero dependencies, follows the same patterns as the existing `session-start` hook:
- Reads PreToolUse JSON from stdin
- Extracts `tool_name` and `tool_input.skill` via sed
- Strips plugin namespace prefix (`superpowers:brainstorming` → `brainstorming`)
- Globs `extensions/<skill-name>/**/*.md` using `find`
- Concatenates content with `## <relative-path>` headers
- Injects via `hookSpecificOutput.additionalContext`
- Passthrough (allow, no injection) for non-Skill tools, skills with no extensions dir, or missing dirs
- Platform-aware output: Claude Code (`hookSpecificOutput`), Cursor (`additional_context`), Copilot CLI (SDK standard)

### Platform Support

Uses `run-hook.cmd` wrapper for Windows (Git Bash detection), same as session-start. Unix runs bash directly.

## Extension Structure

```
extensions/
  brainstorming/guardrails/guardrails.md
  writing-plans/guardrails/guardrails.md
  executing-plans/guardrails/guardrails.md
  test-driven-development/guardrails/guardrails.md
  systematic-debugging/guardrails/guardrails.md
  verification-before-completion/guardrails/guardrails.md
  requesting-code-review/guardrails/guardrails.md
  receiving-code-review/guardrails/guardrails.md
  subagent-driven-development/guardrails/guardrails.md
  finishing-a-development-branch/guardrails/guardrails.md
```

Any `.md` file under `extensions/<skill-name>/` is loaded — nested folders (`checklists/`, `templates/`, etc.) work automatically. Files load in alphabetical order.

## Discipline-to-Skill Mapping

| Discipline | br | wp | ep | tdd | sd | vbc | rcr | rcv | sad | fb |
|---|---|---|---|---|---|---|---|---|---|---|
| 1. Think Before Coding | X | X | — | — | X | — | — | X | X | — |
| 2. Simplicity First | — | X | X | X | — | X | — | — | X | — |
| 3. Surgical Changes | — | — | X | — | X | — | X | — | X | — |
| 4. Goal-Driven Execution | — | — | X | X | X | X | — | — | X | X |
| 5. Assumption Discipline | X | X | — | — | X | — | — | — | — | — |
| 6. Don't Complete Narrative | X | X | — | — | — | — | — | — | — | — |
| 7. Tests Evidence Not Proof | — | — | — | X | — | X | — | — | — | — |
| 8. Long-Session Discipline | — | — | X | — | — | — | — | — | X | — |
| 9. Verify External Claims | — | — | — | — | X | — | — | X | — | — |
| 10. Preserve Plan Integrity | — | — | X | — | — | — | — | — | — | — |
| 11. Design for Failure | X | X | X | — | — | — | — | — | — | — |
| 12. Optimize for System | X | — | X | — | — | — | — | — | — | — |

Key: br=brainstorming, wp=writing-plans, ep=executing-plans, tdd=test-driven-development, sd=systematic-debugging, vbc=verification-before-completion, rcr=requesting-code-review, rcv=receiving-code-review, sad=subagent-driven-development, fb=finishing-a-development-branch

### Skills Without Guardrails

- **using-superpowers** — bootstrap/meta, doesn't guide code generation
- **using-git-worktrees** — infrastructure, no code generation guidance
- **dispatching-parallel-agents** — already well-aligned with discipline principles
- **writing-skills** — meta skill for authoring skills, not code generation

## Sub-Agent Propagation

PreToolUse hooks propagate to sub-agents automatically. When a sub-agent dispatched by `subagent-driven-development` invokes `test-driven-development`, the hook fires and injects `extensions/test-driven-development/guardrails/guardrails.md` into the sub-agent's context. Verified empirically.

For raw Agent calls that bypass the Skill tool, `subagent-driven-development`'s guardrails include a propagation rule directing the main agent to inline task-skill guardrails into the sub-agent prompt.

## What This Does NOT Do

- **Does not modify any SKILL.md files.** Guardrails live in extensions/ and are injected at runtime.
- **Does not inject guardrails globally.** Context injection is scoped to the specific skill being invoked.
- **Does not handle non-superpowers skills.** The hook silently passthroughs for skills without extensions directories.

## Verification

| Test | Result |
|---|---|
| Skill tool with extensions dir | Guardrails injected |
| Non-Skill tool (Bash, Write, etc.) | Passthrough |
| Skill with no extensions dir | Passthrough |
| Skill without `superpowers:` prefix | Parsed and works |
| Nested folders (`**/*.md`) | All files loaded, sorted |
| Sub-agent invokes Skill | Guardrails injected in sub-agent context |

## Files Changed

- `hooks/hooks.json` — added PreToolUse entry
- `hooks/skill-extensions` — new PreToolUse hook script (pure bash)
- `extensions/*/guardrails/guardrails.md` — 10 new guardrail files
