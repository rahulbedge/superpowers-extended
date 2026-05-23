# Test-Driven Development Guardrails

## Simplicity First

- Write only the minimal code to make the test pass. Nothing more.
- No extra parameters, abstractions, or "in case we need it" flexibility.
- Before declaring done, re-read your implementation. Could it be simpler? If you wrote 50 lines and it could be 20, rewrite it.

## Goal-Driven Execution

- Write the test FIRST. Watch it fail. Do not implement and then backfill tests.
- If you didn't watch the test fail, you don't know if it tests the right thing.
- Run the test. See green. Do not accept "it seems to work."

## Tests Are Evidence, Not Proof

- Passing tests increase confidence but do not guarantee correctness.
- Before declaring a task complete, ask: Could tests pass while behavior is still wrong? Were edge cases ignored?
- Never substitute passing tests for reasoning. Green tests are a checkpoint, not a certificate.

## Red Flag — Over-engineering

If your implementation is more complex than the test requires — you added parameters, abstractions, or flexibility the test didn't need — simplify before declaring done.
