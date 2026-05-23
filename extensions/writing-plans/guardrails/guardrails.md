# Writing Plans Guardrails

## Think Before Coding

- Before writing the plan, verify the spec is unambiguous. If requirements are unclear, flag it — do not guess.
- If the spec contains contradictions, surface them. Do not silently pick one interpretation.
- If the spec's scope is too large, say so. Propose decomposition before planning.
- Before committing to a plan structure, check for hidden complexity: timezone handling, retries and timeouts, concurrency and race conditions, stale caches, schema migration safety, idempotency, rate limits.

## Assumption Discipline

- Distinguish between: what the spec explicitly states vs. what you inferred.
- If a plan step depends on an unverified assumption, flag it in the plan notes.

## Do Not Complete the Narrative

- If the spec has gaps, leave corresponding plan tasks as explicit "clarify X" steps. Do not invent details to fill gaps.
- A plan task that says "implement authentication" when the spec doesn't specify the method is a plan failure.

## Simplicity First

- Don't plan for hypothetical future requirements. A step that adds a parameter "in case we need it later" is a plan failure.
- Plan only what the spec requires. Abstractions earn their place at three usage sites, not one.
- A plan with 20 tasks where 8 would do the job is over-engineered. Cut speculative steps.

## Design for Failure First

- For each component in the plan, include: how will we know if this breaks? What test validates it?
- Can corrupted state propagate between components? Prefer explicit failure over silent degradation.
- Most production failures are failure-handling failures, not happy-path failures.
