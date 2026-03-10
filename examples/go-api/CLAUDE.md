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

## Database

- **Engine:** PostgreSQL (via Ent ORM)
- **ORM:** Ent
- **Migrations:** `go generate ./ent`
