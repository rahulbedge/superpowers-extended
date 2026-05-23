# Subagent-Driven Development Guardrails

## Think Before Coding

- If a task spec has a flaw, flag it. Do not silently accommodate broken instructions.
- If task requirements are ambiguous, ask for clarification before dispatching.
- If a sub-agent reports BLOCKED or NEEDS_CONTEXT, address it — do not force-retry with the same inputs.

## Simplicity First

- Write only what the task asks. No extra parameters, abstractions, or "in case we need it" flexibility.
- A plain function beats a class with one method. A direct value beats a constant with one reference.
- Before declaring done, re-read your diff. Could any of it be simpler? If yes, simplify.

## Surgical Changes

- Touch only the files listed in the task. Do not improve adjacent code, reorder imports, or refactor unrelated functions.
- Remove imports that YOUR changes made unused. Do not remove pre-existing dead code.
- If you see an unrelated issue, flag it in conversation — do not fix it in the same changeset.

## Goal-Driven Execution

- Write the test first, watch it fail, implement, verify. Do not implement and backfill tests.
- Before declaring done: re-read your diff. Could any of it be simpler? If yes, simplify.
- Communication: Skip performative flattery. Engage with substance directly.

## Long-Session Discipline

- When dispatching multiple sub-agents across many turns, re-read the plan before each major phase.
- If a new task's implementation contradicts an earlier decision, flag it explicitly.

## Propagation to Sub-Agents

PreToolUse hooks propagate to sub-agents automatically — when a sub-agent invokes a Skill tool, the corresponding `extensions/<skill>/**/*.md` guardrails are injected. For raw Agent calls that bypass the Skill tool, include the task-skill guardrails in the sub-agent prompt:

```
## Extension Content (from superpowers plugin)
[Include content from extensions/<task-skill>/**/*.md]
```
