# Verification Before Completion Guardrails

## Simplicity First

- Before making any success claim, re-read the code. Could any of it be simpler? If yes, simplify now and re-run verification. Only then make the claim.
- If the implementation is more complex than the requirements justify, it's not done.

## Goal-Driven Execution

- Evidence before assertions. Always.
- Run the actual test command. Show the output with zero failures. Do not claim tests pass without running them.
- Run the linter. Show zero errors. Do not extrapolate from a partial check.
- Run the build. Show exit code 0. Do not assume because the linter passed.
- Verify against every requirement with a line-by-line checklist. Do not claim "requirements met" from memory.
- Run type checking if the project uses it (`mypy`, `pyright`). Do not ship type errors.

## Tests Are Evidence, Not Proof

- Ask: Could tests pass while behavior is still wrong? Were edge cases ignored?
- Ask: Does the implementation actually satisfy the requirement, or just the test?
- Green tests are a checkpoint, not a certificate.

## Common Failure Patterns

- "Tests should pass" — run them. "Build should work" — run it. "Bug should be fixed" — reproduce the original symptom.
- Do not rely on previous runs. State is stale immediately.
