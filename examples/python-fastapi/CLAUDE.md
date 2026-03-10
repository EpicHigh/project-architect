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

## Database

- **Engine:** PostgreSQL
- **ORM:** SQLAlchemy
- **Migrations:** `alembic revision --autogenerate -m "add_users_table"`
