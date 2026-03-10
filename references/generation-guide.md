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
3. Write a commit message following project conventions:
{{ if commit_format_description }}
   {{ commit_format_description }}
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

1. Run `git diff {{ default_branch }}` to see all changes on this branch.
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

**Trigger:** Backend framework detected (section 8.2).

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
2. Create the endpoint following {{ backend_framework }} conventions:
   - Find an existing endpoint in the codebase and use it as a reference.
{{ if backend_framework == "Express" or backend_framework == "Fastify" }}
   - Add route handler with request/response typing.
{{ end }}
{{ if backend_framework == "NestJS" }}
   - Add controller method with decorator (`@Get`, `@Post`, etc.).
{{ end }}
{{ if backend_framework == "Django" or backend_framework == "FastAPI" or backend_framework == "Flask" }}
   - Add view/route function with appropriate decorator.
{{ end }}
{{ if backend_framework == "Gin" or backend_framework == "Echo" or backend_framework == "Fiber" }}
   - Add handler function and register route.
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
- Push to `{{ default_branch }}` for production, or push to a branch for preview.
- Monitor: `vercel` or check the Vercel dashboard.
{{ end }}
{{ if ci_platform == "Netlify" }}
- Push to `{{ default_branch }}` for production.
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
{{ if workspace_scope }}
   - Create `package.json` with name `{{ workspace_scope }}/{{ name }}`
{{ else }}
   - Create `package.json` with name `{{ name }}`
{{ end }}
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
| `route_file` | Derived from user input (Remix flat-file convention) | `dashboard.settings` |
| `default_branch` | `git symbolic-ref refs/remotes/origin/HEAD` or git history | `main`, `master` |
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

---

## 9.3 Skill Templates

Each skill is generated as a `SKILL.md` file inside `.claude/skills/<skill-name>/`. Skills auto-activate when Claude detects a matching user intent — the `description` field in frontmatter is the primary trigger mechanism.

### Writing Good Skill Descriptions

The description determines when Claude auto-activates the skill. Getting it right is critical:

- **Too broad** → false triggers on unrelated tasks (e.g., "helps with code" triggers on everything)
- **Too narrow** → misses relevant tasks (e.g., "handles PostgreSQL migration rollbacks" misses schema creation)
- **Just right** → lists 3-7 specific intents the skill covers

**Pattern:** Start with a one-sentence purpose, then list trigger intents as bullet points or comma-separated phrases. Use action verbs that match how developers phrase requests.

### Universal Skills (always generate)

#### code-conventions/SKILL.md

**Trigger:** Always generate.

`````markdown
---
name: code-conventions
description: >
  {{ project_name }} coding style and conventions.
  Activates when: writing new code, reviewing style, renaming variables,
  organizing imports, handling errors, structuring files.
---

# Code Conventions for {{ project_name }}

{{ if naming_conventions }}
## Naming

{{ for each naming_convention }}
- **{{ scope }}**: {{ convention }} (e.g., `{{ example }}`)
{{ end }}
{{ end }}

{{ if import_organization_description }}
## Imports

{{ import_organization_description }}
{{ end }}

{{ if error_handling_description }}
## Error Handling

{{ error_handling_description }}
{{ end }}

{{ if file_organization_description }}
## File Organization

{{ file_organization_description }}
{{ end }}

{{ if architecture_pattern_description }}
## Architecture

{{ architecture_pattern_description }}
{{ end }}
`````

#### project-context/SKILL.md

**Trigger:** Always generate.

`````markdown
---
name: project-context
description: >
  {{ project_name }} architecture and project context.
  Activates when: asking about project structure, understanding how modules connect,
  finding where code lives, onboarding to the codebase, making architectural decisions.
---

# Project Context — {{ project_name }}

## Tech Stack

{{ if primary_framework }}
- **Framework:** {{ primary_framework }}
{{ end }}
- **Language:** {{ language }}
{{ if package_manager }}
- **Package Manager:** {{ package_manager }}
{{ end }}
{{ if database_engine }}
- **Database:** {{ database_engine }}
{{ end }}
{{ if orm_name }}
- **ORM:** {{ orm_name }}
{{ end }}

## Directory Structure

{{ for each top_level_directory }}
- `{{ directory_name }}/` — {{ directory_purpose }}
{{ end }}

{{ if monorepo }}
## Workspaces

| Package | Path | Purpose |
|---------|------|---------|
{{ for each workspace }}
| {{ workspace_name }} | `{{ workspace_path }}` | {{ workspace_purpose }} |
{{ end }}
{{ end }}

## Key Commands

{{ if dev_command }}
- **Dev:** `{{ dev_command }}`
{{ end }}
{{ if build_command }}
- **Build:** `{{ build_command }}`
{{ end }}
{{ if test_command }}
- **Test:** `{{ test_command }}`
{{ end }}
{{ if lint_command }}
- **Lint:** `{{ lint_command }}`
{{ end }}
`````

### Conditional Skills

#### design-system/SKILL.md

**Trigger:** Styling framework detected (section 8.2 — Tailwind, shadcn, MUI, Chakra, Styled Components, CSS Modules, Ant Design).

`````markdown
---
name: design-system
description: >
  {{ project_name }} design system and styling patterns.
  Activates when: styling components, choosing colors or spacing, applying theme tokens,
  creating layouts, using {{ styling_framework }} utilities, maintaining visual consistency.
---

# Design System — {{ project_name }}

## Styling Approach

- **Framework:** {{ styling_framework }}
{{ if design_system_config }}
- **Config:** `{{ design_system_config }}`
{{ end }}

{{ if styling_framework == "Tailwind" }}
## Tailwind Conventions

- Reference `tailwind.config` for custom theme values (colors, spacing, breakpoints).
- Use utility classes directly; avoid `@apply` unless creating reusable component styles.
- Follow the project's existing class ordering pattern.
{{ end }}

{{ if component_library }}
## Component Library

- **Library:** {{ component_library }}
- Import components from `{{ component_library_import }}`.
- Follow existing usage patterns found in the codebase.
{{ end }}
`````

#### api-patterns/SKILL.md

**Trigger:** Backend framework detected (section 8.2).

`````markdown
---
name: api-patterns
description: >
  {{ project_name }} API design patterns and conventions.
  Activates when: creating endpoints, designing request/response schemas,
  handling API errors, adding middleware, structuring routes, writing API docs.
---

# API Patterns — {{ project_name }}

## Framework

- **Backend:** {{ backend_framework }}
{{ if api_directory }}
- **Routes directory:** `{{ api_directory }}/`
{{ end }}

## Conventions

- Find existing endpoints with `Grep` and follow the same patterns.
- Check for:
  - Route naming conventions (plural nouns, kebab-case, etc.)
  - Request validation approach
  - Response format (envelope pattern, direct, etc.)
  - Error response structure
{{ if orm_name }}
  - Data access pattern ({{ orm_name }} queries)
{{ end }}

{{ if api_spec }}
## API Specification

- **Spec file:** `{{ api_spec }}`
- Keep spec in sync with implementation.
{{ end }}
`````

#### schema-patterns/SKILL.md

**Trigger:** Database/ORM detected (section 8.9 + section 8.2 ORM).

`````markdown
---
name: schema-patterns
description: >
  {{ project_name }} database schema and data access patterns.
  Activates when: creating models, writing migrations, querying data,
  designing relationships, optimizing queries, managing database schema.
---

# Schema Patterns — {{ project_name }}

## Stack

- **Database:** {{ database_engine }}
{{ if orm_name }}
- **ORM:** {{ orm_name }}
{{ end }}
{{ if schema_directory }}
- **Schema location:** `{{ schema_directory }}/`
{{ end }}

## Conventions

- Find existing models/schemas with `Glob` and follow the same patterns.
- Check for:
  - Naming conventions (table names, column names)
  - Primary key strategy (auto-increment, UUID, etc.)
  - Relationship patterns (foreign keys, join tables)
  - Soft delete vs hard delete
  - Timestamp columns (created_at, updated_at)

{{ if migration_command }}
## Migrations

```sh
{{ migration_command }}
```
{{ end }}
`````

#### test-patterns/SKILL.md

**Trigger:** Test framework detected (section 8.6).

`````markdown
---
name: test-patterns
description: >
  {{ project_name }} testing patterns and conventions.
  Activates when: writing tests, setting up test fixtures, mocking dependencies,
  checking test coverage, debugging failing tests, structuring test files.
---

# Test Patterns — {{ project_name }}

## Framework

- **Test runner:** {{ test_framework }}
{{ if e2e_framework }}
- **E2E:** {{ e2e_framework }}
{{ end }}

## Conventions

- Find existing tests with `Glob` and follow the same structure.
{{ if test_file_pattern }}
- **Test file pattern:** `{{ test_file_pattern }}`
{{ end }}
- Check for:
  - Test organization (describe/it, test suites, table-driven)
  - Setup/teardown patterns (beforeEach, fixtures, factories)
  - Mocking approach (jest.mock, dependency injection, test doubles)
  - Assertion style (expect, assert, should)

## Commands

- **Run all:** `{{ test_command }}`
- **Run one:** `{{ single_test_command }}`
{{ if coverage_command }}
- **Coverage:** `{{ coverage_command }}`
{{ end }}
`````

### Skill Variable Reference

| Variable | Source | Example |
|----------|--------|---------|
| `top_level_directory` | Directory listing of project root | list of `{directory_name, directory_purpose}` |
| `directory_name` | `ls` output | `src`, `tests`, `scripts` |
| `directory_purpose` | Inferred from directory name + contents | `application source code` |
| `design_system_config` | Glob for styling config files | `tailwind.config.ts` |
| `component_library` | Section 8.2 styling framework detection | `shadcn/ui`, `MUI` |
| `component_library_import` | Grep for existing import patterns | `@/components/ui`, `@mui/material` |
| `api_spec` | Glob for OpenAPI/Swagger files | `openapi.yaml`, `swagger.json` |
| `schema_directory` | Glob for schema/model files | `prisma/`, `src/models/` |
| `test_framework` | Section 8.6 test framework detection | `Jest`, `Vitest`, `pytest` |

---

## 9.4 Agent Templates

Agents run in separate context windows or worktrees. Generate only when **all three criteria** are met:

1. **Separate context** — task benefits from its own context window (avoids polluting main conversation)
2. **File conflicts** — task modifies files that could conflict with ongoing work
3. **Validation tooling** — project has tools to verify the agent's output (linter, tests, type checker)

If any criterion is not met, do not generate the agent.

### reviewer.md

**Trigger:** Linter detected (section 8.7) AND test framework detected (section 8.6).

**Justification:** Code review benefits from a fresh perspective (separate context). The reviewer reads but does not modify files. Linter and tests validate its suggestions.

`````markdown
---
description: Review code changes in a separate context for objectivity
model: {{ model }}
allowed-tools: Bash, Read, Grep, Glob
---

# Code Reviewer

You are reviewing changes in {{ project_name }}.

## Process

1. Run `git diff {{ default_branch }}` to see all changes.
2. For each changed file, analyze:
   - Correctness and edge cases
   - Security concerns (OWASP top 10)
   - Performance implications
{{ if naming_conventions }}
   - Adherence to project naming conventions
{{ end }}
{{ if test_command }}
3. Run `{{ test_command }}` to verify tests pass.
{{ end }}
{{ if lint_command }}
4. Run `{{ lint_command }}` to verify lint passes.
{{ end }}
5. Output findings as: **file:line** — severity — description — fix.
`````

### test-writer.md

**Trigger:** Test framework detected (section 8.6).

**Justification:** Writing tests benefits from isolation (worktree) to avoid conflicting with in-progress work. Test framework validates output directly.

`````markdown
---
description: Generate tests for specified files in an isolated worktree
model: {{ model }}
allowed-tools: Bash, Read, Write, Glob, Grep
isolation: worktree
---

# Test Writer

You are writing tests for {{ project_name }}.

## Process

1. Read the target file(s) to understand the code.
2. Find existing tests with `Glob` to learn the project's test patterns:
{{ if test_file_pattern }}
   - Pattern: `{{ test_file_pattern }}`
{{ end }}
3. Write tests covering:
   - Happy path for each public function/method
   - Edge cases (null, empty, boundary values)
   - Error cases and exception handling
4. Run the tests: `{{ single_test_command }}`
5. Fix any failures.
{{ if coverage_command }}
6. Check coverage: `{{ coverage_command }}`
{{ end }}
`````

### refactor-agent.md

**Trigger:** Test framework detected (section 8.6) AND linter detected (section 8.7) AND good test coverage observed.

**Justification:** Refactoring modifies many files (conflict risk). Worktree isolation keeps main work safe. Tests + linter validate that behavior is preserved.

`````markdown
---
description: Refactor code safely in an isolated worktree
model: {{ model }}
allowed-tools: Bash, Read, Write, Glob, Grep
isolation: worktree
---

# Refactor Agent

You are refactoring code in {{ project_name }}.

## Process

1. Run tests first to establish baseline: `{{ test_command }}`
2. Make incremental changes — one refactoring step at a time.
3. After each change:
{{ if lint_command }}
   - Run `{{ lint_command }}`
{{ end }}
   - Run `{{ test_command }}`
   - If tests fail, revert the last change.
4. Keep changes minimal and focused.
5. Do not change behavior — only structure, naming, and organization.
`````

---

## 9.5 Hook Templates

Hooks are configured in `.claude/settings.json`. Generate only when **all three safety conditions** are met:

1. **Binary installed** — tool binary confirmed present (lockfile, config file, or `command -v`)
2. **Fast execution** — command runs in under 30 seconds
3. **Disable instructions** — hook includes a comment explaining how to disable it

If any condition is not met, do not generate the hook.

### Lint pre-commit hook

**Trigger:** Linter detected (section 8.7) AND linter binary confirmed installed.

```json
{
  "hooks": {
    "pre-commit": [
      {
        "command": "{{ lint_command }}",
        "comment": "Runs linter before each commit. To disable: remove this entry from .claude/settings.json"
      }
    ]
  }
}
```

### Lint + test pre-commit hook

**Trigger:** Linter detected AND test framework detected AND tests run in under 30 seconds.

```json
{
  "hooks": {
    "pre-commit": [
      {
        "command": "{{ lint_command }} && {{ test_command }}",
        "comment": "Runs linter and tests before each commit. To disable: remove this entry from .claude/settings.json"
      }
    ]
  }
}
```

### Available lifecycle events

| Event | When it fires |
|-------|--------------|
| `pre-commit` | Before `git commit` |
| `post-commit` | After `git commit` |
| `pre-push` | Before `git push` |

---

## 9.6 MCP Config Template

MCP servers extend Claude's capabilities. Generate `.mcp.json` when relevant tools are detected.

### Context7

**Trigger:** Framework detected that benefits from up-to-date documentation lookup (section 8.2).

**Frameworks that trigger Context7:** React, Next.js, Vue, Nuxt, Svelte, SvelteKit, Angular, Express, Fastify, NestJS, Django, FastAPI, Flask, Tailwind, Prisma, Drizzle.

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@anthropic/context7-mcp@latest"]
    }
  }
}
```

---

## 9.7 Selection Matrix

Quick-reference table mapping Phase 1 detections to Phase 2 outputs. Use this as the primary decision table.

| Detected | Commands | Skills | Agents | Hooks | MCP |
|----------|----------|--------|--------|-------|-----|
| Any project | commit, review, explain | code-conventions, project-context | | | |
| Frontend framework | component, page | design-system | | | Context7 |
| Backend framework | endpoint | api-patterns | | | Context7 |
| Database / ORM | migrate | schema-patterns | | | |
| Test framework | test | test-patterns | test-writer | | |
| E2E framework | e2e | | | | |
| Docker | docker | | | | |
| CI/CD | deploy | | reviewer | | |
| Monorepo | new-package | | | | |
| Linter | | | | lint pre-commit | |
| Linter + fast tests | | | | lint+test pre-commit | |
| Tests + linter + coverage | | | refactor-agent | | |

### Reading the matrix

- **Rows** are Phase 1 detections. Multiple rows can match simultaneously.
- **Columns** are Phase 2 output layers. Each cell lists what to generate.
- Empty cells mean nothing is generated for that combination.
- "page" command requires an app router framework specifically (Next.js, Nuxt, SvelteKit, Remix), not just any frontend framework.
