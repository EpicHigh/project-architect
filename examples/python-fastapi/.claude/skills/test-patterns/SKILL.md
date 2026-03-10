---
name: test-patterns
description: >
  python-fastapi testing patterns and conventions.
  Activates when: writing tests, setting up test fixtures, mocking dependencies,
  checking test coverage, debugging failing tests, structuring test files.
---

# Test Patterns — python-fastapi

## Framework

- **Test runner:** pytest
- **Libraries:** pytest-asyncio, httpx

## Conventions

- Find existing tests with `Glob` and follow the same structure.
- Test file pattern: `tests/test_*.py`

## Commands

- **Run all:** `pytest`
- **Run one:** `pytest tests/test_users.py`
