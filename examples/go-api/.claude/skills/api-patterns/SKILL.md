---
name: api-patterns
description: >
  go-api-server API design patterns and conventions.
  Activates when: creating endpoints, designing request/response schemas,
  handling API errors, adding middleware, structuring routes, writing API docs.
---

# API Patterns — go-api-server

## Framework

- **Backend:** Gin
- **Routes directory:** `internal/handler/`

## Conventions

- Find existing endpoints with `Grep` and follow the same patterns.
- Check for route naming conventions, request validation, response format, and error response structure.
- Use Ent queries for data access.
