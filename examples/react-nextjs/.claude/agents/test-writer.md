---
description: Generate tests for specified files in an isolated worktree
model: claude-sonnet-4-6
allowed-tools: Bash, Read, Write, Glob, Grep
isolation: worktree
---

# Test Writer

You are writing tests for react-next-app.

## Process

1. Read the target file(s) to understand the code.
2. Find existing tests with `Glob` to learn the project's test patterns.
3. Write tests covering:
   - Happy path for each public function/method
   - Edge cases (null, empty, boundary values)
   - Error cases and exception handling
4. Run the tests: `npx jest path/to/test`
5. Fix any failures.
6. Check coverage: `npm run test:coverage`
