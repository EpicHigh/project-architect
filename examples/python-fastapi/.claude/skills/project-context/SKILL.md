---
name: project-context
description: >
  python-fastapi architecture and project context.
  Activates when: asking about project structure, understanding how modules connect,
  finding where code lives, onboarding to the codebase, making architectural decisions.
---

# Project Context — python-fastapi

## Tech Stack

- **Framework:** FastAPI
- **Language:** Python
- **Database:** PostgreSQL
- **ORM:** SQLAlchemy

## Directory Structure

- `app/` — application source code
- `app/routers/` — API route handlers
- `app/models/` — SQLAlchemy models
- `tests/` — test files

## Key Commands

- **Dev:** `uvicorn app.main:app --reload`
- **Test:** `pytest`
- **Lint:** `ruff check .`
