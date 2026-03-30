# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

python-fastapi is a Python web application using FastAPI.

## Build & Development

### Development Server

```sh
uvicorn app.main:app --reload
```

## Testing

### Run All Tests

```sh
pytest
```

### Run a Single Test

```sh
pytest tests/test_users.py
```

## Linting & Formatting

### Lint

```sh
ruff check .
```

### Format

```sh
ruff format .
```

## Working Style

Don't take shortcuts — read and explore before writing. Don't be lazy — produce thorough, complete output with proper error handling, validation, and tests. Don't hallucinate — only reference files, APIs, and imports that actually exist. Don't over-engineer — match the existing codebase's complexity level. Stay on scope — only change what was asked. Always verify — run lint and tests before declaring done.

- **Read existing router structure before adding endpoints** — Routes use `Depends(get_db)` for session injection; endpoints that create their own sessions bypass transaction management
- **Read existing Pydantic schemas in `schemas/` before creating new ones** — This project shares schemas across endpoints; duplicating instead of reusing causes validation drift
- **Run `pytest` before and after changes** — You cannot distinguish pre-existing failures from regressions without a baseline
- **Check Alembic migration state before modifying models** — Generating a migration against an outdated state creates branching conflicts in the migration chain
- **Read `app/dependencies.py` before adding dependency injection** — This project centralizes shared dependencies; duplicating them in individual routers creates inconsistent behavior
- **Implement complete request/response schemas with validation** — An endpoint with `dict` input instead of a Pydantic model bypasses all validation; every endpoint needs typed schemas in `schemas/`
- **Write tests that verify response body structure, not just status codes** — A test that only checks `assert response.status_code == 200` misses every data bug; verify the JSON body matches the Pydantic response schema
- **Only import modules that exist in this project** — Inventing an import like `from app.services.email import send_email` when `app/services/email.py` doesn't exist causes an immediate ImportError
- **Match the existing project structure — don't add layers the codebase doesn't use** — If routes call services directly, don't introduce a repository pattern, event system, or middleware that nothing else uses
- **Only change what was asked — don't refactor adjacent routers** — Being asked to "add a new endpoint" doesn't authorize restructuring existing routes or dependencies; unrelated changes create unreviewed risk
- **Run `ruff check .` and `pytest` before declaring a task complete** — Saying "this should work" without running lint and tests leaves broken code for the user to debug

## Database

- **Engine:** PostgreSQL
- **ORM:** SQLAlchemy
- **Migrations:** `alembic revision --autogenerate -m "add_users_table"`
