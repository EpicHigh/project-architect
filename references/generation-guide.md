# Generation Guide

Reference for Phase 2 of `/project-architect`. Contains guidelines and examples that Claude uses to generate project-specific `.claude/` configuration from Phase 1 scan results.

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

## 9.2 Command Guidelines

Commands are `.md` files in `.claude/commands/`. They orchestrate multi-step workflows with project-specific validation.

### Principles

- Every validation step must use an actual command detected in Phase 1 — no placeholders
- Commands start with context-gathering (explore codebase) before action
- A command adds value when it orchestrates a multi-step workflow — if it's just "run this one command," skip it
- Omit steps that don't apply: no "run tests" step if no test framework was detected

### Quality Criteria

- [ ] Every `run X` step uses a real command from Phase 1
- [ ] No generic advice that applies to any project
- [ ] Commit command embeds the project's actual commit conventions
- [ ] Implement command references the project's actual lint/test/build commands

### Always Generate

`commit`, `implement`, `fix`, `review` — these workflows apply to all projects, but their content must be tailored to the project's detected stack, commands, and conventions from Phase 1.

### Consider Generating

- `optimize-db` — when database/ORM detected
- `security-audit` — when backend framework detected

### Example: commit.md for a TypeScript + ESLint + Conventional Commits project

`````markdown
---
description: Create a guided commit following conventional commit conventions
allowed-tools: Bash, Read, Grep, Glob
---

# Guided Commit

1. Run `git status` and `git diff --staged` to review changes.
2. If nothing is staged, show unstaged changes and ask what to stage.
3. Run `npm run lint` before committing. If it fails, show errors and ask to fix or skip.
4. Write a commit message following conventional commits (lowercase, imperative mood).
5. Run `git commit` with the message.
6. Show the commit hash and summary.
`````

### Example: implement.md for a Go + golangci-lint + go test project

`````markdown
---
description: Implement a feature with structured exploration, planning, and validation
allowed-tools: Bash, Read, Write, Glob, Grep, Agent
---

# Implement Feature

> Tip: For isolated implementation in a separate worktree, invoke the `developer` agent instead.

## Phase 1: Understand

1. Read the user's description. Ask clarifying questions if scope is ambiguous.
2. Define what success looks like.

## Phase 2: Explore

3. Grep for related code: domain terms, similar features, shared utilities.
4. Read existing implementations of the closest analog.
5. Map: which files need to be created or modified?

## Phase 3: Plan

6. Write a plan (3-7 steps) in dependency order.
7. Show the plan and wait for approval before writing code.

## Phase 4: Implement

8. One change at a time. After each:
   - `golangci-lint run ./...`
   - `go test ./...`
9. Write tests for new behavior (table-driven tests with t.Run).

## Phase 5: Validate

10. `go test ./...` — all tests pass
11. `golangci-lint run ./...` — no violations
12. `go build ./...` — build succeeds
13. Summarize what changed and why.
`````

### Frontmatter Reference

| Field | Required | Values |
|-------|----------|--------|
| `description` | Yes | One-line description of the command |
| `allowed-tools` | Yes | Comma-separated: Bash, Read, Write, Glob, Grep, Agent |

---

## 9.3 Skill Guidelines

Skills are `SKILL.md` files in `.claude/skills/<name>/`. They encode **methodology** — how to think about recurring tasks in this specific codebase.

### Principles

- Skills teach decision-making methodology, not information dumps
- A skill answers "how should I approach X in THIS codebase?" — not "here are facts about X"
- The `description` field determines auto-activation — list 3-7 specific intent phrases using action verbs
- Never duplicate CLAUDE.md content: skills are for methodology, CLAUDE.md is for facts
- Skills should reference specific patterns, files, and conventions found in Phase 1

### Quality Criteria

- [ ] Skill contains project-specific methodology, not generic framework docs
- [ ] Each section references actual files/patterns from the scan
- [ ] Principles survive codebase changes (not brittle line-number references)
- [ ] Description uses action verbs matching how developers phrase requests

### Always Generate

- `implement-feature` — structured implementation methodology (explore → plan → implement → validate)
- `fix-bug` — root cause analysis methodology (reproduce → diagnose → fix → verify → prevent)
- `improve-architecture` — architecture improvement methodology (explore → identify → design alternatives → evaluate → recommend)

### Consider Generating

- `tdd` — when test framework detected
- `design-system` — when styling framework detected
- `api-patterns` — when backend framework detected
- `schema-patterns` — when database/ORM detected
- Any other skill that addresses a recurring methodology need you identified in Phase 1

### Example: api-patterns skill for a FastAPI + SQLAlchemy project

`````markdown
---
name: api-patterns
description: >
  API design patterns for this FastAPI project. Activates when: creating endpoints,
  designing request/response schemas, handling API errors, adding middleware,
  structuring routes.
---

# API Patterns

## How Endpoints Are Structured

This project follows a consistent pattern. Before creating a new endpoint, read 2-3 existing routers in `app/api/` to see it in action.

1. **Router file** in `app/api/` — one file per resource (e.g., `users.py`, `invoices.py`)
2. **Pydantic models** for request/response in `app/schemas/` — validate input, shape output
3. **Service layer** in `app/services/` — business logic, separated from HTTP concerns
4. **DB access** via SQLAlchemy in `app/models/` — use `Depends(get_db)` for session injection

## Key Conventions

- Route naming: plural nouns, kebab-case (`/api/v1/tax-invoices`)
- Auth: `Depends(get_current_user)` on protected endpoints
- Errors: raise `HTTPException` with appropriate status codes, never return raw exceptions
- Validation: Pydantic handles it — don't duplicate validation in service layer
`````

### Example: design-system skill for a React + Tailwind + shadcn/ui project

`````markdown
---
name: design-system
description: >
  Design system and styling patterns. Activates when: styling components,
  choosing colors or spacing, creating layouts, using Tailwind utilities,
  working with shadcn/ui components.
---

# Design System

## Before Building UI

1. Check `components/ui/` for shadcn primitives — Button, Card, Dialog, etc. are already there.
2. Check existing pages for similar layouts — reuse before creating.
3. Reference `tailwind.config.ts` for custom theme tokens (colors, spacing, breakpoints).

## Styling Rules

- Use Tailwind utilities directly. Avoid `@apply` unless extracting a reusable component style.
- Follow the existing class ordering pattern (check nearby components).
- Don't introduce new color/spacing values without checking the config first.
- For dark mode: use `dark:` variant classes. The project uses class-based dark mode.
`````

### Frontmatter Reference

| Field | Required | Values |
|-------|----------|--------|
| `name` | Yes | Skill name (kebab-case) |
| `description` | Yes | Multi-line: purpose + activation triggers |

---

## 9.4 Agent Guidelines

Agents are `.md` files in `.claude/agents/`. They are specialist team members that run in separate context windows, each with deep knowledge of the project's specific stack.

### Principles

- An agent embeds **stack-intersection knowledge** — not just "React" advice or "Prisma" advice, but knowledge of how React and Prisma interact in THIS project
- Good test: "If I remove the project name, can I identify which stack this agent targets?" If no, the agent is too generic.
- Agents that write code run in worktrees (`isolation: worktree`); read-only agents don't need isolation
- Every agent needs: persona, philosophy, stack-specific expertise, process with actual commands, deliverables
- An agent is worth generating when: (1) task benefits from separate context, (2) has clear deliverables, (3) project has tooling to validate output

### Quality Criteria

- [ ] Agent references specific files, directories, and patterns found in Phase 1
- [ ] Stack-specific sections reflect the intersection of technologies, not individual frameworks
- [ ] Process uses the project's actual commands for validation
- [ ] The agent would produce materially different output for different stack combinations

### Always Generate

- `architect` — read-only codebase analysis, model: opus

### Consider Generating

- `developer` — when test framework AND linter detected (worktree, writes code)
- `reviewer` — when linter OR test framework detected (read-only, reviews diffs)
- `db-specialist` — when database/ORM detected (read-only, schema/query analysis)
- `devops` — when Docker OR CI/CD detected (read-only, pipeline/container analysis)
- `qa` — when test framework detected (read-only, test gap analysis)
- `fixer` — when test framework detected (worktree, bug fixes)

### Example: developer.md for a Next.js 14 + Prisma + Tailwind + Jest project

This example shows stack-intersection knowledge: RSC boundaries affect where Prisma queries run, Tailwind styling follows specific config, Jest tests colocate with components.

`````markdown
---
description: Implement features with Next.js App Router + Prisma patterns and validation
model: sonnet
allowed-tools: Bash, Read, Write, Glob, Grep
isolation: worktree
---

# Developer

You are a senior TypeScript developer working on this Next.js 14 App Router project with Prisma and Tailwind CSS.

## Stack-Specific Patterns

- **Server Components by default.** Only add `"use client"` when the component needs interactivity (useState, useEffect, event handlers). Data fetching and Prisma queries belong in Server Components or server actions — never in Client Components.
- **Prisma data access:** queries live in `lib/db/` or directly in Server Components. Use `prisma.findMany()` with `select` to limit fields. Check `prisma/schema.prisma` for the data model before writing queries.
- **Tailwind styling:** check `tailwind.config.ts` for custom tokens. Use shadcn/ui components from `components/ui/` before building custom UI.
- **Route organization:** `app/` directory with nested folders. Each route has `page.tsx` (UI), `layout.tsx` (shared layout), optionally `loading.tsx` and `error.tsx`.

## Process

1. **Explore** — read 3-5 similar files to learn the patterns.
2. **Plan** — list files to create/modify. Get approval.
3. **Implement** — one change at a time. After each:
   - `npm run lint`
   - `npx tsc --noEmit`
   - `npm test`
4. **Test** — colocate `*.test.tsx` next to components. Mock Prisma with the singleton pattern from `__mocks__/`.

## Deliverables

- Working implementation following existing patterns.
- Tests for new behavior.
- All validation checks pass.
`````

### Example: developer.md for a Go + Chi + Ent + PostgreSQL project

Different stack, different knowledge. Go idioms, Chi routing, Ent ORM patterns.

`````markdown
---
description: Implement features with Go/Chi patterns, Ent schemas, and PostgreSQL
model: sonnet
allowed-tools: Bash, Read, Write, Glob, Grep
isolation: worktree
---

# Developer

You are a senior Go developer working on this Chi-based API with Ent ORM and PostgreSQL.

## Stack-Specific Patterns

- **Standard layout:** handlers in `cmd/server/`, business logic in `internal/service/`, data access in `internal/repository/`. Keep packages focused — one concern per package.
- **Chi routing:** sub-routers for resource groups (`r.Route("/users", ...)`) with middleware chains. Auth middleware applied at router group level, not individual handlers.
- **Ent ORM:** schemas in `ent/schema/`. Edges define relationships. After schema changes, run `go generate ./ent`. Use eager loading with `.WithEdgeName()` to avoid N+1.
- **Error handling:** return errors up the call stack with `fmt.Errorf("context: %w", err)`. Handle at the HTTP boundary in handlers. Use custom error types in `internal/apperror/` for domain errors.
- **Context:** pass `context.Context` through all layers for cancellation and request-scoped values.

## Process

1. **Explore** — read 3-5 similar handlers/services.
2. **Plan** — list files. Get approval.
3. **Implement** — one change at a time. After each:
   - `make lint` (golangci-lint)
   - `go test ./...`
4. **Test** — table-driven tests with `t.Run`. Test helpers in `internal/testutil/`. Use `testify/assert` for assertions.

## Deliverables

- Working implementation following existing patterns.
- Table-driven tests for new behavior.
- All checks pass.
`````

### Example: reviewer.md for a Python + FastAPI + SQLAlchemy + pytest project

Shows how a reviewer embeds stack-specific checklists from the project's actual technologies.

`````markdown
---
description: Review code changes with FastAPI/SQLAlchemy-specific checklists and security awareness
model: sonnet
allowed-tools: Bash, Read, Grep, Glob
---

# Reviewer

You are a code reviewer for this FastAPI + SQLAlchemy project.

## Review Process

1. Run `git diff main` to see all changes.
2. Apply the checklists below to each changed file.
3. Run `pytest` — report failures.
4. Run `ruff check .` — report violations.

## FastAPI Checklist

- Pydantic models validate all request input — no manual validation in route functions.
- `Depends()` used correctly for DB session, auth, and shared dependencies.
- Async endpoints for I/O-bound operations (DB queries, external API calls).
- Proper HTTP status codes: 201 for creation, 404 for not found, 422 for validation errors.

## SQLAlchemy Checklist

- Session scoping: `Depends(get_db)` per request, not global sessions.
- N+1 prevention: use `selectinload()` or `joinedload()` for relationship access.
- No raw SQL string interpolation — use parameterized queries or ORM methods.

## Security Checklist

- Auth decorator on every state-changing endpoint.
- No secrets in code (API keys, tokens, passwords).
- Input validation via Pydantic — no trusting raw request data.
- CORS configured correctly in `main.py`.

## Output

Tag findings: **blocker** / **suggestion** / **nit**

Format: `**file:line** — severity — description — suggested fix`

End with summary: findings count by severity, verdict (approve / request changes).
`````

### Frontmatter Reference

| Field | Required | Values |
|-------|----------|--------|
| `description` | Yes | One-line description |
| `model` | Yes | `sonnet` (default), `opus` (for architect) |
| `allowed-tools` | Yes | Comma-separated tool list |
| `isolation` | No | `worktree` for agents that write code |

### Composition Notes

When composing agents for a project, ask yourself for each agent:

- **What does this agent know about THIS project's stack intersection that a generic agent would not?** If the answer is nothing, either add project-specific knowledge or skip the agent.
- **Does the agent reference specific files, directories, commands, and patterns from Phase 1?** Generic framework advice belongs in documentation, not agents.
- **Would this agent produce different output for a React+Prisma project vs a React+Mongoose project?** If not, it's too generic.

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

**Frameworks that trigger Context7:** React, Next.js, Vue, Nuxt, Svelte, SvelteKit, Angular, Remix, Astro, Qwik, Express, Fastify, NestJS, Hono, Django, FastAPI, Flask, Tailwind, Prisma, Drizzle, Mongoose, SQLAlchemy.

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

## 9.7 Output Reasoning Guide

After completing Phase 1, use this guide to reason about what outputs would help this specific project. This is a starting point for your reasoning, not a checklist to blindly follow.

### Always Generate

| Output | Category |
|--------|----------|
| CLAUDE.md | Project documentation |
| `commit`, `implement`, `fix`, `review` | Commands |
| `implement-feature`, `fix-bug`, `improve-architecture` | Skills |
| `architect` agent | Agents |

### Consider When Relevant

| When You Detect... | Consider Generating... |
|---------------------|------------------------|
| Styling framework | `design-system` skill |
| Backend framework | `api-patterns` skill, `security-audit` command |
| Database / ORM | `schema-patterns` skill, `optimize-db` command, `db-specialist` agent |
| Test framework | `tdd` skill, `qa` agent, `fixer` agent |
| Linter OR test framework | `reviewer` agent |
| Test framework AND linter | `developer` agent (worktree) |
| Docker OR CI/CD | `devops` agent |
| Linter installed | lint pre-commit hook |
| Linter + fast tests | lint + test pre-commit hook |
| Framework with docs | Context7 MCP server |

### Reasoning, Not Lookup

- If the project's unique stack suggests an agent or skill not listed here, generate it.
- If a listed item would be generic for this project (no stack-specific content to embed), skip it.
- Prefer fewer, higher-quality outputs over many generic ones. Five excellent customizations beat twenty that could apply to any project.
- Every generated file must contain knowledge from Phase 1. If you can't point to a specific detection that makes a line relevant, remove that line.

---

## 9.8 Composition Process

How to compose each output. Follow this process for every command, skill, and agent you generate.

### Step 1: Gather Context

For each output you plan to generate, collect the relevant Phase 1 findings:

- What **frameworks and tools** does this output need to know about?
- What **actual commands** (build, test, lint) does this output need to reference?
- What **file paths and patterns** (route directories, schema files, test locations) did Phase 1 find?
- What **conventions** (naming, imports, error handling) did source file analysis reveal?

### Step 2: Identify Stack Intersections

The most valuable content comes from how technologies **interact**, not what each one does individually:

- Next.js + Prisma → "Prisma queries belong in Server Components or server actions, not Client Components"
- FastAPI + SQLAlchemy → "Use `Depends(get_db)` for session injection, `selectinload()` for eager loading in endpoints"
- Go + Ent + Chi → "After Ent schema changes, run `go generate ./ent`. Use Ent's eager loading in Chi handlers to avoid N+1"
- React + Tailwind + shadcn → "Check `components/ui/` for shadcn primitives before building custom UI. Reference `tailwind.config.ts` for tokens"

Ask: "What does a developer need to know about how **A and B work together** in this project?"

### Step 3: Compose the Content

Write the output from scratch, embedding the context and intersection knowledge. Do not copy examples verbatim. Follow the structural requirements (frontmatter, headings) but make the content unique to this project.

### Step 4: Validate Before Writing

Before writing each file, check:

- [ ] **Specificity test:** If I remove the project name, can I identify which stack this targets?
- [ ] **Detection trace:** Can every line trace back to a Phase 1 detection?
- [ ] **Intersection test:** Does the output contain knowledge about how detected technologies interact — not just individual framework docs?
- [ ] **Command test:** Does every `run X` step use a real command found in Phase 1?
- [ ] **Omission test:** If a tool wasn't detected (no linter, no tests, no DB), are references to it omitted?

---

## 9.9 Edge Cases and Fallbacks

### Project With No Test Framework

- Skip: `tdd` skill, `qa` agent, `fixer` agent, `developer` agent (requires tests for validation)
- Keep: `implement` and `fix` commands — but remove all "run tests" steps from them
- The `reviewer` agent can still be generated if a linter exists

### Project With No Linter

- Skip: lint pre-commit hook, lint+test pre-commit hook
- The `developer` agent requires both tests AND linter — skip if linter is missing
- The `reviewer` agent can still be generated if tests exist
- Remove all "run lint" steps from commands

### New Project (No Git History)

- Phase 1.6 (git analysis) returns empty — this is normal
- Skip: git conventions section in CLAUDE.md (no commit history to infer from)
- Commit command: use a sensible default ("conventional commits, lowercase, imperative mood") but note it's a suggestion, not a detected convention

### Monorepo

- CLAUDE.md: include the Workspace Structure table with each package's path and purpose
- Commands: validation steps should target the relevant workspace, not root (e.g., `cd packages/web && npm run lint` instead of `npm run lint`)
- Skills: scope methodology to the workspace being worked on. An `api-patterns` skill for `packages/api` should reference that package's route structure, not the root
- Agents: the `developer` agent should know the workspace layout and which package to work in. Include workspace navigation guidance ("check which package the target file belongs to before running validation commands")
- Consider generating: workspace-specific skills if packages have significantly different stacks (e.g., Python backend + React frontend)

### Multiple Databases

- If both PostgreSQL and Redis are detected, the `db-specialist` agent should cover both
- `schema-patterns` skill should focus on the primary relational DB, with a note about cache patterns if Redis is detected
- `optimize-db` command should scope to the relational DB (schema/query optimization), not the cache

### Library (No Web/API Framework)

- Skip: `api-patterns` skill, `security-audit` command, frontend-specific agents
- Focus on: code quality (reviewer), testing (qa), and API design of the library's public interface
- Developer agent should focus on: backward compatibility, type safety, documentation

---

## 9.10 Quality Validation Checklist

Run this checklist after generating all outputs, before presenting to the user.

### Per-File Checks

For each generated file:

- [ ] **No placeholders remaining** — no `{{ }}`, no `TODO`, no `[FILL IN]`
- [ ] **Uses real commands** — every shell command was detected in Phase 1, not assumed
- [ ] **Stack-specific content** — contains knowledge unique to this project's technology combination
- [ ] **Correct file path** — placed in the right directory (`.claude/commands/`, `.claude/skills/<name>/`, `.claude/agents/`)
- [ ] **Valid frontmatter** — YAML frontmatter has all required fields

### Cross-File Checks

- [ ] **No contradictions** — CLAUDE.md commands match what's in `.claude/commands/`
- [ ] **Consistent tool references** — if CLAUDE.md says `npm test`, agents/commands also say `npm test` (not `npx jest`)
- [ ] **No duplicate content** — skills don't repeat what's in CLAUDE.md; agents don't repeat what's in skills
- [ ] **Hooks use validated commands** — hook commands were confirmed installed (Phase 1 should have run `command -v`)

### Completeness Checks

- [ ] **CLAUDE.md generated** — always required
- [ ] **Universal commands generated** — commit, implement, fix, review
- [ ] **Universal skills generated** — implement-feature, fix-bug, improve-architecture
- [ ] **Architect agent generated** — always required
- [ ] **INSTRUCTION.md generated** — unless one already exists
- [ ] **Conditional outputs match detections** — if DB detected, schema-patterns skill exists; if tests detected, tdd skill exists; etc.

---

## 9.11 INSTRUCTION.md Template

After Phase 2 generates all `.claude/` configuration and passes the quality validation checklist (section 9.10), produce an `INSTRUCTION.md` in the project root as a quick-start onboarding guide. This is tailored to what was actually generated — not a generic Claude Code tutorial.

### Rules

- Output must be under 150 lines
- Every section is conditional — only include sections for layers that were actually generated
- Content must reference the developer's actual project (stack names, framework versions, real command names)
- No `{{ placeholders }}` may remain in the final output
- Use a friendly, conversational tone — the reader just bootstrapped and should feel confident
- Include a note at the top: "This file was generated by project-architect. Feel free to edit or delete it."

### Template

`````markdown
<!-- This file was generated by project-architect. Feel free to edit or delete it. -->

# Getting Started with Your Claude Code Setup

{{ summary_paragraph }}

{{ if commands_generated }}

## Your Commands

| Command | What it does | Try it |
|---------|-------------|--------|
{{ for each generated command }}
| `/{{ command_name }}` | {{ one_line_description }} | `{{ example_usage }}` |
{{ end }}

{{ end }}

{{ if skills_generated }}

## Your Skills

Skills activate automatically when Claude detects relevant context. You don't need to invoke them — just ask naturally.

{{ for each generated skill }}
- **{{ skill_name }}** — {{ description }}. Try: "{{ natural_language_trigger }}"
{{ end }}

{{ end }}

{{ if agents_generated }}

## Your Agents

Agents run in separate context windows for tasks that benefit from focused expertise.

{{ for each generated agent }}
- **{{ agent_name }}** — {{ what_it_does }}. Invoke with: `{{ invocation_example }}`
{{ end }}

{{ end }}

{{ if hooks_generated }}

## Your Hooks

Hooks run automatically at specific lifecycle events. Each can be disabled individually.

{{ for each generated hook }}
- **{{ hook_event }}** — {{ what_it_does }}
  - To disable: remove the corresponding entry from `.claude/settings.json`
{{ end }}

{{ end }}

{{ if mcp_generated }}

## Your MCP Servers

External tools are now available to Claude through MCP:

{{ for each mcp_server }}
- **{{ server_name }}** — {{ what_it_provides }}
{{ end }}

{{ end }}

## Tips for Getting the Most Out of It

{{ for each stack_specific_tip }}
- {{ stack_specific_tip }}
{{ end }}

## Customizing Your Setup

- Edit `CLAUDE.md` to update project conventions or add new rules
- Add commands in `.claude/commands/` — any markdown file becomes a slash command
- Add skills in `.claude/skills/` — create a directory with a `SKILL.md` file
{{ if hooks_generated }}
- Review hooks in `.claude/settings.json` — remove any you don't want
{{ end }}
`````
