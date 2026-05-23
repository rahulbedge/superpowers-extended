# Systematic Debugging Guardrails

## Think Before Coding

- Complete root cause investigation before writing a single line of fix code. Do not skip to implementation.
- Form a single hypothesis, state it clearly: "I think X is the root cause because Y."
- If you don't understand something, say so. Do not pretend to know.
- Complete each phase before proceeding to the next. Do not jump ahead.

## Surgical Changes

- Fix the root cause, not the symptom. ONE change at a time. One variable at a time.
- No "while I'm here" improvements. No bundled refactoring.
- If 3+ fixes fail: STOP. Question the architecture. Discuss with your human partner before attempting more fixes.

## Goal-Driven Execution

- Create a failing test case that reproduces the bug BEFORE fixing. Simplest possible reproduction.
- Verify the fix: test passes now? No other tests broken? Issue actually resolved?
- If the fix doesn't work: count attempts. < 3: re-analyze. >= 3: question architecture.

## Assumption Discipline

- Never present assumptions as established facts. "The migration appears additive based on visible files" — not "the system is horizontally scalable."
- Communicate certainty proportional to evidence. "The migration appears additive based on the visible files" is correct. "The system is horizontally scalable" without evidence is not.
- Verify external claims against current documentation or the actual codebase. Do not rely on training-data recall for version-specific details.

## Verify External Claims

- Training-data recall is the least reliable source. Prefer: directly observed codebase > current documentation > session-retrieved information > training knowledge > speculation.
- When correctness depends on external behavior (API semantics, library versions, infrastructure), verify against current documentation.
