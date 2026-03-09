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

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

{{ project_name }} is a {{ language }} {{ project_type }} using {{ primary_framework }}.

{{ if monorepo }}
### Workspace Structure

| Package | Path | Purpose |
|---------|------|---------|
{{ for each workspace }}
| {{ workspace_name }} | `{{ workspace_path }}` | {{ workspace_purpose }} |
{{ end }}
{{ end }}

## Build & Development

{{ if build_command }}
### Build
```sh
{{ build_command }}
```
{{ end }}

### Development Server
```sh
{{ dev_command }}
```

{{ if additional_dev_commands }}
{{ for each additional_dev_commands }}
### {{ command_label }}
```sh
{{ command_value }}
```
{{ end }}
{{ end }}

## Testing

### Run All Tests
```sh
{{ test_command }}
```

### Run a Single Test
```sh
{{ single_test_command }}
```

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

## Code Conventions

{{ if naming_conventions }}
### Naming
{{ for each naming_convention }}
- {{ scope }}: {{ convention }} (e.g., `{{ example }}`)
{{ end }}
{{ end }}

{{ if import_conventions }}
### Imports
{{ import_organization_description }}
{{ end }}

{{ if error_handling_pattern }}
### Error Handling
{{ error_handling_description }}
{{ end }}

{{ if architecture_pattern }}
### Architecture
{{ architecture_pattern_description }}
{{ end }}

{{ if file_organization }}
### File Organization
{{ file_organization_description }}
{{ end }}

## Git Conventions

{{ if commit_format }}
### Commits
{{ commit_format_description }}
{{ end }}

{{ if branch_naming }}
### Branches
{{ branch_naming_description }}
{{ end }}

{{ if database }}
## Database

- **Engine:** {{ database_engine }}
- **ORM:** {{ orm_name }}
{{ if migration_command }}
- **Migrations:** `{{ migration_command }}`
{{ end }}
{{ end }}
```

### Variable Reference

| Variable | Source | Example |
|----------|--------|---------|
| `project_name` | `package.json` name, `go.mod` module, `Cargo.toml` package name, or directory name | `my-app` |
| `language` | Section 8.1 language detection | `TypeScript` |
| `project_type` | Section 8.5 project pattern detection | `monorepo`, `web application`, `library` |
| `primary_framework` | Section 8.2 framework detection (highest-signal match) | `Next.js 14`, `Express`, `Django` |
| `build_command` | Section 8.14 script detection → `build` script | `npm run build` |
| `dev_command` | Section 8.14 script detection → `dev` or `start` script | `npm run dev` |
| `test_command` | Section 8.6 test framework detection → test runner command | `npm test`, `go test ./...` |
| `single_test_command` | Section 8.6 test command extraction | `npx jest path/to/test`, `go test ./pkg/...` |
| `e2e_command` | Section 8.6 E2E framework detection | `npx playwright test` |
| `lint_command` | Section 8.7 linter detection → lint script or direct command | `npm run lint` |
| `format_command` | Section 8.7 formatter detection → format script or direct command | `npx prettier --write .` |
| `typecheck_command` | Section 8.7 or script detection → typecheck script | `npx tsc --noEmit` |
| `naming_conventions` | Section 1.5 source file analysis | `camelCase for variables` |
| `import_conventions` | Section 1.5 source file analysis | `grouped by external/internal` |
| `error_handling_pattern` | Section 1.5 source file analysis | `Result type for errors` |
| `architecture_pattern` | Section 1.5 source file analysis | `repository pattern` |
| `commit_format` | Section 8.12 git convention detection | `conventional commits, lowercase` |
| `branch_naming` | Section 8.12 git convention detection | `feature/*, fix/*, main` |
| `database_engine` | Section 8.9 database detection | `PostgreSQL` |
| `orm_name` | Section 8.2 ORM framework detection | `Prisma`, `SQLAlchemy` |
| `migration_command` | Section 8.14 script detection or ORM conventions | `npx prisma migrate dev` |
| `monorepo` | Section 8.5 monorepo detection | `true` / `false` |
| `workspace_name` | Section 8.5 workspace discovery | `@app/web` |
| `workspace_path` | Section 8.5 workspace discovery | `packages/web` |

### Section Inclusion Rules

| Section | Include When |
|---------|-------------|
| Project Overview | Always |
| Workspace Structure | Monorepo detected (section 8.5) |
| Build & Development | Build or dev script found (section 8.14) |
| Testing | Test framework detected (section 8.6) |
| Linting & Formatting | Linter or formatter detected (section 8.7) |
| Code Conventions | Patterns found in source files (section 1.5) |
| Git Conventions | Patterns found in git history (section 8.12) |
| Database | Database detected (section 8.9) |

<!-- Sections 9.2–9.7 will be added in Stories 11–13 -->
