# Executing Plans Guardrails

## Simplicity First

- Write exactly what the plan task asks. Nothing more.
- A plain function beats a class with one method. A direct value beats a constant with one reference.
- No features beyond what the task specifies. "I also added filtering" — that wasn't requested.
- No abstractions for single-use code. If only one caller exists, don't extract a helper.
- No error handling for scenarios that can't happen. If the code guarantees a value exists, don't wrap it in `if None`.
- Stdlib beats a new dependency. Every dependency is a maintenance liability.

## Surgical Changes

- Touch only the files listed in the plan task. Do not improve adjacent code, refactor unrelated functions, clean up imports, or reorganize structure.
- If you see an unrelated issue, flag it in conversation — do not fix it in the same changeset.
- Remove imports that YOUR changes made unused. Do not remove pre-existing dead code.
- Review your diff before declaring done. Every changed line should trace directly to the task.
- Match existing style. If the file uses single quotes, use single quotes. If it omits type hints in tests, omit them. Consistency beats personal preference.

## Goal-Driven Execution

- Restate vague tasks as verifiable goals before starting.
- Write the test first. Watch it fail. Then implement.
- Before declaring done: re-read your diff. Could any of it be simpler? If yes, simplify.
- Run the relevant tests. Show the output. Do not claim tests pass without running them.
- Run type checking if the project uses it (`mypy`, `pyright`). Do not ship type errors.
- If you hit an unexpected obstacle, surface it immediately. Do not silently work around it.

## Preserve Plan Integrity

- Follow the plan exactly. Do not silently mutate the architecture during implementation.
- If implementation pressure suggests changing direction: stop, explain the pressure, present the tradeoff, get approval.
- A cleaner implementation of the wrong architecture is still wrong.

## Long-Session Discipline

- Re-read the plan before each major implementation phase. Do not let recent context overwrite earlier decisions.
- If a new decision contradicts an earlier one, flag it explicitly.

## Design for Failure First

- Before finalizing an implementation, ask: How does this fail? How is failure detected? Does it fail loudly or silently?
- Can corrupted state propagate from this change? Prefer explicit failure over silent degradation.

## Optimize for System Behavior, Not Local Elegance

- A cleaner abstraction is not automatically a better system. Evaluate changes against: operational simplicity, debuggability, observability, failure isolation, maintenance burden.
- If the choice is between a beautiful abstraction and a debuggable system, pick debuggable.
