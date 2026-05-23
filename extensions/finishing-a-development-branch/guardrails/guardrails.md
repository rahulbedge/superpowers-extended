# Finishing a Development Branch Guardrails

## Goal-Driven Execution

- Verify tests pass before presenting any options. Do not offer merge/PR if tests are failing.
- Verify the build succeeds before declaring anything complete.
- Run a final diff review: does every changed line trace to the intended work? If you can't explain why a line changed, revert it.

## Quality Gates

- Tests pass with zero failures → gate passed
- Linter clean with zero errors → gate passed
- Build succeeds with exit 0 → gate passed
- Diff tells a single, clear story → gate passed
- All gates must pass before merge, PR, or handoff.
