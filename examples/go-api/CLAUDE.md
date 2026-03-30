# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

go-api-server is a Go web application using Gin.

## Build & Development

### Build

```sh
make build
```

### Development Server

```sh
make run
```

## Testing

### Run All Tests

```sh
make test
```

### Run a Single Test

```sh
go test ./internal/handler/...
```

## Linting & Formatting

### Lint

```sh
make lint
```

## Working Style

Don't take shortcuts — read and explore before writing. Don't be lazy — produce thorough, complete output with proper error handling, validation, and tests. Don't hallucinate — only reference files, APIs, and imports that actually exist. Don't over-engineer — match the existing codebase's complexity level. Stay on scope — only change what was asked. Always verify — run lint and tests before declaring done.

- **Run `go generate ./ent` after schema changes, then read generated types** — The generated API in `ent/` changes after every schema modification; coding against stale types causes compile errors
- **Read existing middleware chain before adding handlers** — Routes inherit middleware from parent `r.Group()` in Gin; re-registering the same middleware on a child group causes it to run twice for that group's routes
- **Run `make test` before and after changes** — You cannot distinguish pre-existing failures from regressions without a baseline
- **Read `internal/handler/` patterns before adding endpoints** — This project follows a consistent handler → service → repository layering; skipping the service layer couples handlers directly to Ent queries
- **Check Ent migration state before modifying schemas** — Generating a migration against an outdated state creates branching conflicts in the migration chain
- **Implement complete handler → service → repository for each endpoint** — A handler that calls Ent directly skips the service layer and makes the endpoint untestable; every endpoint needs all three layers
- **Return structured error responses, not raw Go errors** — An endpoint that returns `err.Error()` as plain text exposes internals; use the project's error response format in `internal/handler/response.go`
- **Only import packages that exist in `go.mod`** — Inventing an import like `github.com/project/internal/utils` when that package doesn't exist causes compile failures; verify with Glob before importing
- **Match the existing abstraction level — don't add layers the codebase doesn't use** — If handlers call services directly, don't introduce a repository interface, event bus, or factory pattern that nothing else uses
- **Only change what was asked — don't refactor adjacent handlers** — Being asked to "add a new endpoint" doesn't authorize restructuring the router or existing handlers; unrelated changes create unreviewed risk
- **Run `make lint` and `make test` before declaring a task complete** — Saying "this should work" without running lint and tests leaves broken code for the user to debug

## Database

- **Engine:** PostgreSQL (via Ent ORM)
- **ORM:** Ent
- **Migrations:** `go generate ./ent`
