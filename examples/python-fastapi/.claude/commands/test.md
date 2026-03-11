---
description: Create or run tests for a file or feature
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Testing

## Modes

### Run tests for a file

```sh
pytest tests/test_users.py
```

### Create a new test

1. For the target file, create a test file:
   - Follow pattern: `tests/test_*.py`
2. Write tests covering:
   - Happy path
   - Edge cases (empty input, None, boundary values)
   - Error cases
3. Run the test: `pytest tests/test_users.py`
