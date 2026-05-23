# Requesting Code Review Guardrails

## Surgical Changes

- When reviewing a diff, flag any changes that touch files outside the task scope.
- Flag adjacent-code "improvements," import reordering, or unrelated refactoring. These are scope violations.
- Flag any line in the diff that cannot be traced to a specific task requirement.

## Simplicity First (Review Criteria)

- Flag over-abstraction: classes with one method, parameters "for future use," abstractions without three usage sites.
- Flag unused flexibility: config knobs for unrequested behavior, extension points "in case we need them later."
- Ask: could this be done with less code? If yes, flag it.
