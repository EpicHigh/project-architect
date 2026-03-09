# Generation Guide

Reference for Phase 2 of `/project-architect`. Contains templates with `{{ variable }}` placeholders that Claude fills in using Phase 1 scan results.

**Rule: every generated line must trace to a Phase 1 detection. No generic advice.**

---

## 9.1 CLAUDE.md Template

### Rules

- Output must be under 200 lines
- Every line must be project-specific — no generic advice like "write clean code" or "follow best practices"
- Only include sections where Phase 1 found relevant data
- Omit a section entirely rather than filling it with generic content

### Template

`````markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

{{ if primary_framework }}
{{ project_name }} is a {{ language }} {{ project_type }} using {{ primary_framework }}.
{{ else }}
{{ project_name }} is a {{ language }} {{ project_type }}.
{{ end }}

{{ if monorepo }}
### Workspace Structure

| Package | Path | Purpose |
|---------|------|---------|
{{ for each workspace }}
| {{ workspace_name }} | `{{ workspace_path }}` | {{ workspace_purpose }} |
{{ end }}
{{ end }}

{{ if build_command or dev_command }}
## Build & Development

{{ if build_command }}
### Build
```sh
{{ build_command }}
```
{{ end }}

{{ if dev_command }}
### Development Server
```sh
{{ dev_command }}
```
{{ end }}

{{ if additional_dev_commands }}
{{ for each additional_dev_commands }}
### {{ command_label }}
```sh
{{ command_value }}
```
{{ end }}
{{ end }}
{{ end }}

{{ if test_command or e2e_framework }}
## Testing

{{ if test_command }}
### Run All Tests
```sh
{{ test_command }}
```

### Run a Single Test
```sh
{{ single_test_command }}
```
{{ end }}

{{ if e2e_framework }}
### E2E Tests
```sh
{{ e2e_command }}
```
{{ end }}

{{ if coverage_command }}
### Coverage
```sh
{{ coverage_command }}
```
{{ end }}
{{ end }}

{{ if lint_command or format_command or typecheck_command }}
## Linting & Formatting

{{ if lint_command }}
### Lint
```sh
{{ lint_command }}
```
{{ end }}

{{ if format_command }}
### Format
```sh
{{ format_command }}
```
{{ end }}

{{ if typecheck_command }}
### Type Check
```sh
{{ typecheck_command }}
```
{{ end }}
{{ end }}

{{ if naming_conventions or import_organization_description or error_handling_description or architecture_pattern_description or file_organization_description }}
## Code Conventions

{{ if naming_conventions }}
### Naming
{{ for each naming_convention }}
- {{ scope }}: {{ convention }} (e.g., `{{ example }}`)
{{ end }}
{{ end }}

{{ if import_organization_description }}
### Imports
{{ import_organization_description }}
{{ end }}

{{ if error_handling_description }}
### Error Handling
{{ error_handling_description }}
{{ end }}

{{ if architecture_pattern_description }}
### Architecture
{{ architecture_pattern_description }}
{{ end }}

{{ if file_organization_description }}
### File Organization
{{ file_organization_description }}
{{ end }}
{{ end }}

{{ if commit_format_description or branch_naming_description }}
## Git Conventions

{{ if commit_format_description }}
### Commits
{{ commit_format_description }}
{{ end }}

{{ if branch_naming_description }}
### Branches
{{ branch_naming_description }}
{{ end }}
{{ end }}

{{ if database }}
## Database

- **Engine:** {{ database_engine }}
{{ if orm_name }}
- **ORM:** {{ orm_name }}
{{ end }}
{{ if migration_command }}
- **Migrations:** `{{ migration_command }}`
{{ end }}
{{ end }}
`````

### Variable Reference

| Variable | Source | Example |
|----------|--------|---------|
| `project_name` | `package.json` name, `go.mod` module, `Cargo.toml` package name, or directory name | `my-app` |
| `language` | Section 8.1 language detection | `TypeScript` |
| `project_type` | Section 8.5 project pattern detection | `monorepo`, `web application`, `library` |
| `primary_framework` | Section 8.2 framework detection (highest-signal match); omit if none detected | `Next.js 14`, `Express`, `Django` |
| `monorepo` | Section 8.5 monorepo detection | `true` / `false` |
| `workspace_name` | Section 8.5 workspace discovery | `@app/web` |
| `workspace_path` | Section 8.5 workspace discovery | `packages/web` |
| `workspace_purpose` | Section 8.5 workspace discovery + directory listing | `frontend application` |
| `build_command` | Section 8.14 script detection → `build` script | `npm run build` |
| `dev_command` | Section 8.14 script detection → `dev` or `start` script | `npm run dev` |
| `additional_dev_commands` | Section 8.14 script detection → other dev-related scripts | list of `{command_label, command_value}` |
| `command_label` | Section 8.14 script detection → script name | `Seed Database` |
| `command_value` | Section 8.14 script detection → script command | `npm run db:seed` |
| `test_command` | Section 8.6 test framework detection → test runner command | `npm test`, `go test ./...` |
| `single_test_command` | Section 8.6 test command extraction | `npx jest path/to/test`, `go test ./pkg/...` |
| `e2e_framework` | Section 8.6 E2E framework detection; presence flag | `Playwright`, `Cypress` |
| `e2e_command` | Section 8.6 E2E framework detection → runner command | `npx playwright test` |
| `coverage_command` | Section 8.14 script detection → coverage script | `npm run test:coverage` |
| `lint_command` | Section 8.7 linter detection → lint script or direct command | `npm run lint` |
| `format_command` | Section 8.7 formatter detection → format script or direct command | `npx prettier --write .` |
| `typecheck_command` | Section 8.7 or script detection → typecheck script | `npx tsc --noEmit` |
| `naming_conventions` | Section 1.5 source file analysis; list of naming patterns found | list of `{scope, convention, example}` |
| `scope` | Section 1.5 source file analysis → naming scope | `variables`, `types`, `files` |
| `convention` | Section 1.5 source file analysis → naming pattern | `camelCase`, `PascalCase` |
| `example` | Section 1.5 source file analysis → example identifier | `getUserById`, `UserService` |
| `import_organization_description` | Section 1.5 source file analysis → import pattern summary; omit if empty | `Grouped by external, then internal` |
| `error_handling_description` | Section 1.5 source file analysis → error pattern summary; omit if empty | `Uses Result<T, E> for all fallible operations` |
| `architecture_pattern_description` | Section 1.5 source file analysis → architecture summary; omit if empty | `Repository pattern with service layer` |
| `file_organization_description` | Section 1.5 source file analysis → file org summary; omit if empty | `Feature-based: each feature in its own directory` |
| `commit_format_description` | Section 8.12 git convention detection → commit format summary; omit if empty | `Conventional commits, lowercase, imperative mood` |
| `branch_naming_description` | Section 8.12 git convention detection → branch pattern summary; omit if empty | `feature/*, fix/*, main` |
| `database` | Section 8.9 database detection; presence flag | `true` / `false` |
| `database_engine` | Section 8.9 database detection | `PostgreSQL` |
| `orm_name` | Section 8.2 ORM framework detection | `Prisma`, `SQLAlchemy` |
| `migration_command` | Section 8.14 script detection or ORM conventions | `npx prisma migrate dev` |

### Section Inclusion Rules

| Section | Include When |
|---------|-------------|
| Project Overview | Always |
| Workspace Structure | Monorepo detected (section 8.5) |
| Build & Development | Build or dev script found (section 8.14) |
| Testing | Test framework or E2E framework detected (section 8.6) |
| Linting & Formatting | Linter, formatter, or typecheck command detected (section 8.7) |
| Code Conventions | Any convention description populated from source files (section 1.5) |
| Git Conventions | Commit format or branch naming description populated (section 8.12) |
| Database | Database detected (section 8.9) |

---

## 9.2 Command Templates

Each command is generated as a `.md` file in `.claude/commands/`. Templates include YAML frontmatter (description, allowed-tools) and a body with `{{ variable }}` placeholders.

### Universal Commands (always generate)

#### commit.md

**Trigger:** Always generate.

`````markdown
---
description: Create a guided commit following project conventions
allowed-tools: Bash, Read, Grep, Glob
---

# Guided Commit

## Steps

1. Run `git status` and `git diff --staged` to review changes.
2. If nothing is staged, show unstaged changes and ask what to stage.
3. Write a commit message following these conventions:
{{ if commit_format_description }}
   {{ commit_format_description }}
{{ else }}
   - Use conventional commits: `type: short summary`
   - Types: feat, fix, refactor, chore, docs, test, style, perf, ci
   - Imperative mood, lowercase
{{ end }}
4. Run `git commit` with the message.
5. Show the commit hash and summary.

{{ if lint_command }}
## Pre-commit Check

Run `{{ lint_command }}` before committing. If it fails, show errors and ask to fix or skip.
{{ end }}
`````

#### review.md

**Trigger:** Always generate.

`````markdown
---
description: Review code changes for bugs, style, and improvements
allowed-tools: Bash, Read, Grep, Glob
---

# Code Review

## What to Review

{{ if branch_naming_description }}
1. Run `git log main..HEAD --oneline` to see commits on this branch.
{{ else }}
1. Run `git diff main` to see all changes.
{{ end }}
2. For each changed file, check:
   - Correctness: logic errors, edge cases, null/undefined handling
   - Security: injection, XSS, secrets, OWASP top 10
{{ if naming_conventions }}
   - Naming: follows project conventions ({{ for each naming_convention }}{{ scope }}: {{ convention }}{{ end }})
{{ end }}
{{ if test_command }}
   - Test coverage: new code has tests, existing tests still pass
{{ end }}
   - Readability: clear intent, no unnecessary complexity

## Output Format

For each finding:
- **File:line** — severity (bug/warning/nit) — description — suggested fix
`````

#### explain.md

**Trigger:** Always generate.

`````markdown
---
description: Explain code, architecture, or project decisions
allowed-tools: Read, Grep, Glob
---

# Explain Code

Explain the requested code, file, or architectural concept.

## Guidelines

- Start with a one-sentence summary of what it does.
- Explain the "why" before the "how."
{{ if architecture_pattern_description }}
- Reference the project's architecture: {{ architecture_pattern_description }}
{{ end }}
{{ if primary_framework }}
- Use {{ primary_framework }} terminology where appropriate.
{{ end }}
- For files: explain purpose, key functions, and how it connects to the rest of the codebase.
- For functions: explain parameters, return value, side effects, and callers.
- Keep explanations concise — prefer examples over abstract descriptions.
`````

### Conditional Commands

#### component.md

**Trigger:** Frontend framework detected (section 8.2 — React, Vue, Svelte, Angular, Solid).

`````markdown
---
description: Generate a new {{ frontend_framework }} component
allowed-tools: Read, Write, Glob, Grep
---

# New Component

## Arguments

- **name** (required): Component name in PascalCase

## Steps

1. Determine the component directory:
{{ if component_directory }}
   - Place in `{{ component_directory }}/`
{{ else }}
   - Find the existing component directory pattern using `Glob`.
{{ end }}
2. Create the component file:
{{ if frontend_framework == "React" }}
   - `{{ component_extension }}` file with a functional component
   - {{ if typescript }}Include TypeScript props interface{{ end }}
{{ end }}
{{ if frontend_framework == "Vue" }}
   - `.vue` file with `<script setup>`, `<template>`, and `<style>` blocks
{{ end }}
{{ if frontend_framework == "Svelte" }}
   - `.svelte` file with `<script>`, markup, and `<style>` blocks
{{ end }}
{{ if frontend_framework == "Angular" }}
   - `.component.ts`, `.component.html`, and `.component.css` files
{{ end }}
{{ if styling_framework }}
3. Apply {{ styling_framework }} classes for styling.
{{ end }}
{{ if test_command }}
4. Create a test file next to the component.
{{ end }}
`````

#### page.md

**Trigger:** App router framework detected (section 8.2 — Next.js, Nuxt, SvelteKit, Remix).

`````markdown
---
description: Create a new {{ app_router_framework }} page/route
allowed-tools: Read, Write, Glob, Grep
---

# New Page

## Arguments

- **route** (required): URL path (e.g., `/dashboard/settings`)

## Steps

1. Convert route to file path:
{{ if app_router_framework == "Next.js" }}
   - Create `{{ pages_directory }}/{{ route_segments }}/page.{{ extension }}`
{{ end }}
{{ if app_router_framework == "Nuxt" }}
   - Create `pages/{{ route_segments }}.vue`
{{ end }}
{{ if app_router_framework == "SvelteKit" }}
   - Create `src/routes/{{ route_segments }}/+page.svelte`
{{ end }}
{{ if app_router_framework == "Remix" }}
   - Create `app/routes/{{ route_file }}.{{ extension }}`
{{ end }}
2. Add the page component with:
   - Default export
   - Basic layout structure
{{ if styling_framework }}
   - {{ styling_framework }} classes
{{ end }}
{{ if test_command }}
3. Create a test file for the page.
{{ end }}
`````

#### endpoint.md

**Trigger:** Backend framework detected (section 8.2 — Express, Fastify, NestJS, Django, FastAPI, Flask, Gin, Echo, Fiber, Spring, Rails, Laravel).

`````markdown
---
description: Create a new {{ backend_framework }} API endpoint
allowed-tools: Read, Write, Glob, Grep
---

# New Endpoint

## Arguments

- **method** (required): HTTP method (GET, POST, PUT, DELETE, PATCH)
- **path** (required): URL path (e.g., `/api/users/:id`)

## Steps

1. Determine the appropriate file:
{{ if api_directory }}
   - Look in `{{ api_directory }}/` for existing routes.
{{ else }}
   - Find the route registration pattern using `Grep`.
{{ end }}
2. Create the endpoint:
{{ if backend_framework == "Express" or backend_framework == "Fastify" }}
   - Add route handler with request/response typing
{{ end }}
{{ if backend_framework == "NestJS" }}
   - Add controller method with decorator (`@Get`, `@Post`, etc.)
{{ end }}
{{ if backend_framework == "Django" or backend_framework == "FastAPI" or backend_framework == "Flask" }}
   - Add view/route function with appropriate decorator
{{ end }}
{{ if backend_framework == "Gin" or backend_framework == "Echo" or backend_framework == "Fiber" }}
   - Add handler function and register route
{{ end }}
3. Include:
   - Input validation
   - Error handling following project patterns
{{ if orm_name }}
   - {{ orm_name }} query for data access
{{ end }}
{{ if test_command }}
4. Create a test for the endpoint.
{{ end }}
`````

#### migrate.md

**Trigger:** Database/ORM detected (section 8.9 + section 8.2 ORM).

`````markdown
---
description: Create and run a database migration
allowed-tools: Bash, Read, Write, Glob
---

# Database Migration

## Arguments

- **name** (required): Migration name (e.g., `add_users_table`, `add_email_to_posts`)

## Steps

1. Create the migration:
{{ if orm_name == "Prisma" }}
   - Edit `prisma/schema.prisma` with the schema change.
   - Run `npx prisma migrate dev --name {{ name }}`.
{{ end }}
{{ if orm_name == "Drizzle" }}
   - Add/modify schema in the drizzle schema directory.
   - Run `npx drizzle-kit generate` then `npx drizzle-kit migrate`.
{{ end }}
{{ if orm_name == "TypeORM" }}
   - Run `npx typeorm migration:generate -n {{ name }}`.
{{ end }}
{{ if orm_name == "SQLAlchemy" }}
   - Run `alembic revision --autogenerate -m "{{ name }}"`.
{{ end }}
{{ if orm_name == "Django ORM" }}
   - Update the model in the appropriate `models.py`.
   - Run `python manage.py makemigrations` then `python manage.py migrate`.
{{ end }}
{{ if orm_name == "Ent" }}
   - Run `go generate ./ent` after modifying the schema.
{{ end }}
{{ if orm_name == "GORM" }}
   - Update the model struct and run `AutoMigrate`.
{{ end }}
2. Review the generated migration file.
3. Run the migration against the dev database.
{{ if test_command }}
4. Run tests to verify nothing broke.
{{ end }}
`````

#### test.md

**Trigger:** Test framework detected (section 8.6).

`````markdown
---
description: Create or run tests for a file or feature
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Testing

## Modes

### Run tests for a file
```sh
{{ single_test_command }}
```

### Create a new test

1. For the target file, create a test file:
{{ if test_file_pattern }}
   - Follow pattern: `{{ test_file_pattern }}`
{{ else }}
   - Find existing test files with `Glob` and follow the same pattern.
{{ end }}
2. Write tests covering:
   - Happy path
   - Edge cases (empty input, null, boundary values)
   - Error cases
3. Run the test: `{{ single_test_command }}`

{{ if coverage_command }}
### Check coverage
```sh
{{ coverage_command }}
```
{{ end }}
`````

#### e2e.md

**Trigger:** E2E framework detected (section 8.6 — Playwright, Cypress, Selenium).

`````markdown
---
description: Create or run end-to-end tests
allowed-tools: Bash, Read, Write, Glob, Grep
---

# E2E Testing

## Run all E2E tests
```sh
{{ e2e_command }}
```

## Create a new E2E test

1. Create a test file in `{{ e2e_directory }}/`.
{{ if e2e_framework == "Playwright" }}
2. Use Playwright's `test` and `expect` API.
3. Use `page.goto()`, `page.click()`, `page.fill()` for interactions.
{{ end }}
{{ if e2e_framework == "Cypress" }}
2. Use Cypress's `cy.visit()`, `cy.get()`, `cy.click()` API.
3. Place in `cypress/e2e/` directory.
{{ end }}
4. Test the critical user flow end-to-end.
5. Run: `{{ e2e_command }}`
`````

#### docker.md

**Trigger:** Docker detected (section 8.11 — Dockerfile or docker-compose present).

`````markdown
---
description: Build, run, or manage Docker containers
allowed-tools: Bash, Read, Write, Glob
---

# Docker

## Common Tasks

{{ if has_dockerfile }}
### Build
```sh
docker build -t {{ project_name }} .
```

### Run
```sh
docker run {{ docker_run_flags }} {{ project_name }}
```
{{ end }}

{{ if has_docker_compose }}
### Start all services
```sh
{{ docker_compose_command }} up -d
```

### View logs
```sh
{{ docker_compose_command }} logs -f
```

### Stop all services
```sh
{{ docker_compose_command }} down
```

### Rebuild
```sh
{{ docker_compose_command }} up -d --build
```
{{ end }}
`````

#### deploy.md

**Trigger:** CI/CD detected (section 8.8).

`````markdown
---
description: Prepare and trigger a deployment
allowed-tools: Bash, Read, Grep, Glob
---

# Deploy

## Pre-deployment Checklist

{{ if lint_command }}
1. Lint: `{{ lint_command }}`
{{ end }}
{{ if test_command }}
2. Tests: `{{ test_command }}`
{{ end }}
{{ if build_command }}
3. Build: `{{ build_command }}`
{{ end }}

## Deploy

{{ if ci_platform == "GitHub Actions" }}
- Push to the deploy branch or create a release tag.
- Monitor: check the Actions tab or run `gh run list`.
{{ end }}
{{ if ci_platform == "GitLab CI" }}
- Push to the deploy branch.
- Monitor: check the CI/CD pipelines page.
{{ end }}
{{ if ci_platform == "Vercel" }}
- Push to main for production, or push to a branch for preview.
- Monitor: `vercel` or check the Vercel dashboard.
{{ end }}
{{ if ci_platform == "Netlify" }}
- Push to main for production.
- Monitor: check the Netlify dashboard.
{{ end }}
{{ if ci_platform == "Railway" or ci_platform == "Fly.io" or ci_platform == "Render" }}
- Push to the linked branch.
- Monitor: check the {{ ci_platform }} dashboard.
{{ end }}
`````

#### new-package.md

**Trigger:** Monorepo detected (section 8.5).

`````markdown
---
description: Create a new package in the monorepo
allowed-tools: Bash, Read, Write, Glob, Grep
---

# New Package

## Arguments

- **name** (required): Package name (e.g., `utils`, `api-client`)
- **type** (optional): `lib` or `app` (default: `lib`)

## Steps

1. Create directory: `{{ workspace_root }}/{{ name }}/`
2. Initialize package config:
{{ if package_manager == "pnpm" or package_manager == "npm" or package_manager == "yarn" }}
   - Create `package.json` with name `{{ workspace_scope }}/{{ name }}`
{{ end }}
{{ if monorepo_tool == "Nx" }}
   - Create `project.json` with targets for build, test, lint.
{{ end }}
{{ if monorepo_tool == "Turborepo" }}
   - Ensure `turbo.json` pipeline covers the new package's tasks.
{{ end }}
3. Add standard files:
   - `src/index.{{ extension }}` — entry point
   - `tsconfig.json` (if TypeScript)
{{ if test_command }}
   - Test file following project pattern
{{ end }}
4. Register the package:
{{ if package_manager == "pnpm" }}
   - Verify `pnpm-workspace.yaml` glob covers `{{ workspace_root }}/*`
{{ end }}
{{ if package_manager == "npm" or package_manager == "yarn" }}
   - Verify `package.json` workspaces glob covers `{{ workspace_root }}/*`
{{ end }}
5. Run `{{ install_command }}` to link the new package.
`````

### Command Variable Reference

| Variable | Source | Example |
|----------|--------|---------|
| `frontend_framework` | Section 8.2 frontend framework detection | `React`, `Vue`, `Svelte` |
| `component_directory` | Glob for existing component patterns | `src/components` |
| `component_extension` | Section 8.1 language + 8.2 framework | `.tsx`, `.jsx`, `.vue` |
| `typescript` | Section 8.1 TypeScript detection | `true` / `false` |
| `styling_framework` | Section 8.2 styling framework detection | `Tailwind`, `CSS Modules` |
| `app_router_framework` | Section 8.2 app router framework detection | `Next.js`, `Nuxt`, `SvelteKit` |
| `pages_directory` | Glob for existing page/route patterns | `src/app`, `app` |
| `route_segments` | Derived from user input | `dashboard/settings` |
| `extension` | Section 8.1 language detection | `tsx`, `ts`, `js` |
| `backend_framework` | Section 8.2 backend framework detection | `Express`, `FastAPI`, `Gin` |
| `api_directory` | Glob for existing route/controller patterns | `src/routes`, `app/api` |
| `test_file_pattern` | Glob for existing test file patterns | `__tests__/*.test.ts`, `*_test.go` |
| `e2e_directory` | Section 8.6 E2E framework detection | `e2e/`, `cypress/e2e/` |
| `has_dockerfile` | Section 8.11 Dockerfile detection | `true` / `false` |
| `has_docker_compose` | Section 8.11 docker-compose detection | `true` / `false` |
| `docker_run_flags` | Derived from Dockerfile (EXPOSE ports) | `-p 3000:3000` |
| `docker_compose_command` | Section 8.11 compose file variant | `docker compose`, `docker-compose` |
| `ci_platform` | Section 8.8 CI/CD platform detection | `GitHub Actions`, `Vercel` |
| `workspace_root` | Section 8.5 workspace discovery | `packages`, `apps` |
| `workspace_scope` | Section 8.5 workspace discovery → package prefix | `@myorg` |
| `monorepo_tool` | Section 8.5 monorepo detection | `Nx`, `Turborepo`, `Lerna` |
| `package_manager` | Section 8.3 package manager detection | `pnpm`, `npm`, `yarn` |
| `install_command` | Section 8.3 package manager detection | `pnpm install`, `npm install` |

<!-- Sections 9.3–9.7 will be added in Stories 12–13 -->
