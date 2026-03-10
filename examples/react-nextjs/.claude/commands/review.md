---
description: Review code changes for bugs, style, and improvements
allowed-tools: Bash, Read, Grep, Glob
---

# Code Review

## What to Review

1. Run `git diff main` to see all changes on this branch.
2. For each changed file, check:
   - Correctness: logic errors, edge cases, null/undefined handling
   - Security: injection, XSS, secrets, OWASP top 10
   - Test coverage: new code has tests, existing tests still pass
   - Readability: clear intent, no unnecessary complexity

## Output Format

For each finding:
- **File:line** — severity (bug/warning/nit) — description — suggested fix
