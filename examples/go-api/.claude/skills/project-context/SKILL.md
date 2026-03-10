---
name: project-context
description: >
  go-api-server architecture and project context.
  Activates when: asking about project structure, understanding how modules connect,
  finding where code lives, onboarding to the codebase, making architectural decisions.
---

# Project Context — go-api-server

## Tech Stack

- **Framework:** Gin
- **Language:** Go
- **Database:** PostgreSQL
- **ORM:** Ent

## Directory Structure

- `cmd/server/` — application entry point
- `internal/handler/` — HTTP handlers
- `internal/repository/` — data access layer
- `internal/service/` — business logic
- `pkg/middleware/` — shared middleware

## Key Commands

- **Dev:** `make run`
- **Build:** `make build`
- **Test:** `make test`
- **Lint:** `make lint`
