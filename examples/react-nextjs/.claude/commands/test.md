---
description: Create or run tests for a file or feature
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Testing

## Modes

### Run tests for a file

```sh
npx jest path/to/test
```

### Create a new test

1. For the target file, create a test file:
   - Follow pattern: `__tests__/*.test.tsx` or `*.test.tsx` next to the file
2. Write tests covering:
   - Happy path
   - Edge cases (empty input, null, boundary values)
   - Error cases
3. Run the test: `npx jest path/to/test`

### Check coverage

```sh
npm run test:coverage
```
