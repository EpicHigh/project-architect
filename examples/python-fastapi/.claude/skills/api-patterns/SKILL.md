---
name: api-patterns
description: >
  python-fastapi API design patterns and conventions.
  Activates when: creating endpoints, designing request/response schemas,
  handling API errors, adding middleware, structuring routes, writing API docs.
---

# API Patterns — python-fastapi

## Framework

- **Backend:** FastAPI
- **Routes directory:** `app/routers/`

## Conventions

- Find existing endpoints with `Grep` and follow the same patterns.
- Check for route naming conventions, Pydantic request/response models, and error handling.
- Use SQLAlchemy queries for data access.
