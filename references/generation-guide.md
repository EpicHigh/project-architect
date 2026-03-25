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

### Generate When Detected (mandatory)

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

Skills are `SKILL.md` files in `.claude/skills/<name>/`. They encode **methodology** — how to think about recurring tasks in this specific codebase. Based on [Anthropic's official skill best practices](https://github.com/anthropics/skills/tree/main/skills/skill-creator).

### Principles

1. **Description is the trigger** — The `description` field is the PRIMARY mechanism that determines when Claude activates the skill. Write ~100 words that are "a little pushy" — explicitly state WHEN to use this skill with 5+ action-verb trigger phrases. Combat Claude's natural under-triggering tendency by being specific about contexts where the skill applies.

2. **Explain WHY, not just rules** — Appeal to Claude's theory of mind. Instead of rigid MUSTs and all-caps ALWAYS/NEVER, explain the reasoning behind each guideline. Claude follows reasoning better than rote commands.

3. **Lean instructions** — Every section must earn its place. Remove things that aren't pulling weight. If a guideline doesn't change behavior, cut it. Read transcripts of Claude using the skill to identify unproductive steps.

4. **Progressive disclosure** — Keep SKILL.md under 500 lines. If you need more depth, use `references/` subdirectory for larger content the skill can point to.

5. **Concrete examples** — Include at least 2 Input/Output pairs showing the pattern in action with real project code. These are more effective than abstract rules.

6. **No duplication with CLAUDE.md** — Skills teach methodology ("how to approach X"). CLAUDE.md teaches facts ("what tools/commands exist"). Never repeat CLAUDE.md content in a skill.

### Skill Structure

```
.claude/skills/<name>/
├── SKILL.md           # Required — instructions + methodology
└── evals/
    └── evals.json     # Required — 2-3 test prompts + assertions
```

### SKILL.md Anatomy

```markdown
---
name: skill-name
description: >
  ~100 words. Be pushy about when to activate. Use action verbs.
  Include 5+ specific trigger phrases that match how developers
  phrase requests. Example: "Use when: creating API endpoints,
  adding new routes, designing request schemas, handling API errors,
  adding middleware, structuring route handlers, connecting routes
  to services."
---

# Skill Title

## Why This Matters
Brief context on why this methodology exists in this project.
Appeal to reasoning, not just authority.

## Methodology
Step-by-step approach with WHY for each step.

## Examples
At least 2 concrete Input/Output pairs from the actual project.

## Patterns to Follow
Project-specific patterns with file references.

## Anti-Patterns
Common mistakes in this codebase and why they cause problems.
```

### Evals (evals.json)

Every generated skill MUST include `evals/evals.json` with 2-3 realistic test prompts. Evals verify the skill produces correct behavior.

**Schema:**

```json
{
  "skill_name": "skill-name",
  "evals": [
    {
      "id": 1,
      "prompt": "What a real developer would type",
      "expected_output": "Description of what correct output looks like",
      "assertions": [
        "Objectively verifiable assertion 1",
        "Objectively verifiable assertion 2"
      ]
    }
  ]
}
```

**Rules for evals:**
- Prompts must be realistic — what a developer would actually say, not artificial test cases
- Assertions must be **objectively verifiable** (can check yes/no) and **discriminating** (fail when the skill really fails, pass when it succeeds)
- Skip assertions for subjective qualities (writing style, design aesthetics)
- 2-3 evals per skill is sufficient — these are for iteration speed, not exhaustive coverage

### Quality Criteria

- [ ] Description is ~100 words and includes 5+ specific trigger phrases with action verbs
- [ ] Description is "pushy" — tells Claude WHEN to use this skill, not just what it does
- [ ] Instructions explain WHY (theory of mind), not just rigid rules
- [ ] Contains at least 2 concrete Input/Output examples from the actual project
- [ ] SKILL.md is under 500 lines
- [ ] No duplicate content with CLAUDE.md (skills = methodology, CLAUDE.md = facts)
- [ ] References actual files, directories, patterns from Phase 1
- [ ] Principles survive codebase changes (not brittle line-number references)
- [ ] `evals/evals.json` exists with 2-3 test prompts and objectively verifiable assertions
- [ ] **Connection check:** Skill references which agent(s) apply it

### Always Generate

- `implement-feature` — structured implementation methodology (explore → plan → implement → validate)
- `fix-bug` — root cause analysis methodology (reproduce → diagnose → fix → verify → prevent)
- `improve-architecture` — architecture improvement methodology (explore → identify → design alternatives → evaluate → recommend)

### Generate When Detected (mandatory)

- `tdd` — when test framework detected
- `design-system` — when styling framework detected
- `api-patterns` — when backend framework detected
- `schema-patterns` — when database/ORM detected
- Any additional skill that addresses a recurring methodology need identified in Phase 1

### Example: api-patterns skill for a FastAPI + SQLAlchemy project

`````markdown
---
name: api-patterns
description: >
  API route design patterns for this FastAPI + SQLAlchemy project. Use this skill
  when: creating new API endpoints, adding route handlers, designing request or
  response Pydantic schemas, handling API errors or validation, adding middleware,
  structuring router files, connecting routes to the service layer, setting up
  dependency injection for database sessions, or reviewing existing endpoint
  patterns. This skill teaches the 4-layer pattern (router → schema → service → model)
  that keeps endpoints consistent and testable.
---

# API Patterns

## Why This Pattern Exists

This project separates HTTP concerns from business logic using a 4-layer architecture.
This matters because it keeps endpoints testable (you can test services without HTTP),
prevents business logic from leaking into route handlers, and makes it easy for multiple
endpoints to share the same service logic.

## The 4-Layer Pattern

Before creating a new endpoint, read 2-3 existing routers in `app/api/` to see this in action.

1. **Router file** in `app/api/` — one file per resource (e.g., `users.py`, `invoices.py`)
2. **Pydantic models** in `app/schemas/` — validate input, shape output
3. **Service layer** in `app/services/` — business logic, separated from HTTP
4. **DB access** via SQLAlchemy in `app/models/` — use `Depends(get_db)` for session injection

## Examples

**Example 1: Creating a new CRUD endpoint**

Input: "Create an endpoint for managing invoices"

Output pattern:
```python
# app/api/invoices.py
router = APIRouter(prefix="/api/v1/invoices", tags=["invoices"])

@router.post("/", response_model=InvoiceResponse)
async def create_invoice(
    data: InvoiceCreate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    return await invoice_service.create(db, data, user)
```

**Example 2: Adding error handling**

Input: "Handle the case where an invoice is not found"

Output pattern:
```python
invoice = await invoice_service.get_by_id(db, invoice_id)
if not invoice:
    raise HTTPException(status_code=404, detail="Invoice not found")
```
Why `HTTPException` instead of returning a dict: FastAPI auto-generates OpenAPI error docs
from HTTPException, and middleware can catch it consistently.

## Anti-Patterns

- **Don't put business logic in route handlers** — if you need an `if/else` beyond input
  validation, it belongs in the service layer
- **Don't create Pydantic models in the router file** — they live in `app/schemas/`
- **Don't duplicate Pydantic validation in services** — Pydantic already validated the input
`````

**Corresponding evals/evals.json:**

`````json
{
  "skill_name": "api-patterns",
  "evals": [
    {
      "id": 1,
      "prompt": "Create a new API endpoint for managing invoices with CRUD operations",
      "expected_output": "Router file with endpoints following the 4-layer pattern",
      "assertions": [
        "Creates router file in app/api/ directory",
        "Uses Pydantic models from app/schemas/ for request/response",
        "Delegates business logic to a service in app/services/",
        "Uses Depends(get_db) for database session injection",
        "Uses Depends(get_current_user) for authentication"
      ]
    },
    {
      "id": 2,
      "prompt": "Add error handling to the invoices endpoint for not-found cases",
      "expected_output": "HTTPException usage with appropriate status codes",
      "assertions": [
        "Uses HTTPException (not plain dict responses) for errors",
        "Returns 404 status code for not-found cases",
        "Error handling is in the route handler, not the service layer"
      ]
    }
  ]
}
`````

### Example: design-system skill for a React + Tailwind + shadcn/ui project

`````markdown
---
name: design-system
description: >
  UI component and styling patterns for this React 19 + Tailwind CSS 4 + shadcn/ui
  project. Use this skill when: building new UI components, styling existing components,
  choosing between shadcn primitives and custom components, applying Tailwind utility
  classes, creating responsive layouts, implementing dark mode, picking colors or spacing
  from the theme config, composing dialog or form layouts, reviewing component structure,
  or deciding how to organize component files. This skill prevents reinventing existing
  primitives and keeps styling consistent with the design system.
---

# Design System

## Why This Matters

This project uses shadcn/ui (Radix primitives + Tailwind) instead of a custom component
library. This matters because shadcn components are copy-pasted into `components/ui/` and
can be customized — but they should be the starting point, not bypassed. When developers
skip existing primitives, they create inconsistent UIs that don't respect theme tokens,
break dark mode, and duplicate effort.

## Before Building Any UI

1. Check `components/ui/` for existing shadcn primitives — Button, Card, Dialog, etc. are already there.
2. Check existing pages for similar layouts — reuse before creating.
3. Reference `tailwind.config.ts` for custom theme tokens (colors, spacing, breakpoints).

## Examples

**Example 1: Creating a form with validation**

Input: "Build a form for editing user profile"

Output pattern:
```tsx
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export function ProfileForm() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Edit Profile</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="space-y-2">
          <Label htmlFor="name">Name</Label>
          <Input id="name" placeholder="Enter name" />
        </div>
        <Button type="submit">Save</Button>
      </CardContent>
    </Card>
  )
}
```
Why shadcn Card + Input instead of custom divs: these primitives handle focus management,
accessibility attributes, and theme tokens automatically.

**Example 2: Conditional styling**

Input: "Style a badge that changes color based on status"

Output pattern:
```tsx
import { cn } from "@/lib/utils"

function StatusBadge({ status }: { status: "active" | "pending" | "rejected" }) {
  return (
    <span className={cn(
      "rounded-full px-2 py-1 text-xs font-medium",
      status === "active" && "bg-green-100 text-green-800",
      status === "pending" && "bg-yellow-100 text-yellow-800",
      status === "rejected" && "bg-red-100 text-red-800",
    )}>
      {status}
    </span>
  )
}
```
Why `cn()` helper: it merges Tailwind classes correctly using `clsx` + `tailwind-merge`,
avoiding class conflicts when conditionally applying styles.

## Anti-Patterns

- **Don't use inline `style={}` props** — use Tailwind utilities. Inline styles bypass the
  theme and break dark mode
- **Don't create custom Button/Input/Card components** — shadcn versions exist in `components/ui/`
- **Don't hardcode colors** — use theme tokens from `tailwind.config.ts` (e.g., `text-primary` not `text-blue-600`)
`````

**Corresponding evals/evals.json:**

`````json
{
  "skill_name": "design-system",
  "evals": [
    {
      "id": 1,
      "prompt": "Build a settings page with a form for updating notification preferences",
      "expected_output": "Component using shadcn primitives with Tailwind utility classes",
      "assertions": [
        "Uses shadcn/ui components from components/ui/ (Card, Button, Input, etc.)",
        "Uses Tailwind utility classes for styling (not inline styles)",
        "Uses cn() helper from lib/utils for conditional classes",
        "Imports use @/ path alias"
      ]
    },
    {
      "id": 2,
      "prompt": "Add a status indicator badge that shows different colors for draft, published, and archived",
      "expected_output": "Badge component with conditional Tailwind classes",
      "assertions": [
        "Uses cn() helper for conditional class merging",
        "Uses Tailwind color utilities (not inline styles or hardcoded hex)",
        "Does not create a custom base component when shadcn Badge exists"
      ]
    }
  ]
}
`````

### Description Anti-Pattern

To help distinguish good from bad descriptions, here's what NOT to write:

**Bad (too short, not pushy, no trigger phrases):**
```yaml
description: Design system and styling patterns for this project.
```

**Bad (describes WHAT, not WHEN to use):**
```yaml
description: >
  This skill contains information about the project's UI components,
  Tailwind configuration, and shadcn/ui primitives.
```

**Good (pushy, ~100 words, 5+ trigger phrases with action verbs):**
```yaml
description: >
  UI component and styling patterns for this React 19 + Tailwind CSS 4 + shadcn/ui
  project. Use this skill when: building new UI components, styling existing components,
  choosing between shadcn primitives and custom components, applying Tailwind utility
  classes, creating responsive layouts, implementing dark mode, picking colors or spacing
  from the theme config, composing dialog or form layouts, reviewing component structure,
  or deciding how to organize component files.
```

### Frontmatter Reference

| Field | Required | Values |
|-------|----------|--------|
| `name` | Yes | Skill name (kebab-case) |
| `description` | Yes | ~100 words: purpose + 5+ trigger phrases with action verbs. Be pushy. |

---

## 9.4 Agent Guidelines: Fetch & Tailor from agency-agents

Agents are `.md` files in `.claude/agents/`. They are sourced from the [agency-agents](https://github.com/msitarzewski/agency-agents) repository (144+ production-quality agent definitions) and **tailored** to the specific project using Phase 1 scan results.

### Fetch Source

Base URL: `https://raw.githubusercontent.com/msitarzewski/agency-agents/main/`

**IMPORTANT:** Use `curl -s` via Bash to fetch agents (NOT WebFetch). WebFetch processes content through an AI model and returns a summary — not the raw markdown file. You need the raw content to write as-is. Example: `curl -s https://raw.githubusercontent.com/msitarzewski/agency-agents/main/engineering/engineering-security-engineer.md`

### Detection → Agent Mapping

Select agents based on Phase 1 detections. Fetch from the corresponding file, then tailor.

| When You Detect... | Fetch Agent | File Path |
|---------------------|------------|-----------|
| Always | Software Architect | `engineering/engineering-software-architect.md` |
| Always | Product Manager | `product/product-manager.md` |
| Always | Code Reviewer | `engineering/engineering-code-reviewer.md` |
| Frontend framework | Frontend Developer | `engineering/engineering-frontend-developer.md` |
| Frontend framework | UI Designer | `design/design-ui-designer.md` |
| Backend framework | Backend Architect | `engineering/engineering-backend-architect.md` |
| Backend framework | Security Engineer | `engineering/engineering-security-engineer.md` |
| Test framework | API Tester | `testing/testing-api-tester.md` |
| Test framework | Performance Benchmarker | `testing/testing-performance-benchmarker.md` |
| Database/ORM | Database Optimizer | `engineering/engineering-database-optimizer.md` |
| Docker OR CI/CD | DevOps Automator | `engineering/engineering-devops-automator.md` |
| Large/complex project | SRE | `engineering/engineering-sre.md` |
| Frontend + accessibility needs | Accessibility Auditor | `testing/testing-accessibility-auditor.md` |
| ML/AI dependencies | AI Engineer | `engineering/engineering-ai-engineer.md` |
| Mobile (React Native/Flutter/Swift) | Mobile App Builder | `engineering/engineering-mobile-app-builder.md` |
| Any project with docs needs | Technical Writer | `engineering/engineering-technical-writer.md` |

This is a starting point. If the project's unique characteristics suggest an agent not listed here, browse the catalog below for the correct filename.

### agency-agents Repository Structure

Complete catalog of available agents with descriptions. Use `curl -s https://raw.githubusercontent.com/msitarzewski/agency-agents/main/{path}` to fetch.

#### engineering/

| File | Description |
|------|-------------|
| `engineering-software-architect.md` | System design, domain-driven design, architectural patterns, technical decisions for scalable systems |
| `engineering-senior-developer.md` | Premium implementation specialist — full-stack, advanced patterns |
| `engineering-code-reviewer.md` | Constructive code review focused on correctness, maintainability, security, performance |
| `engineering-frontend-developer.md` | Modern web technologies, React/Vue/Angular, UI implementation, performance optimization |
| `engineering-backend-architect.md` | Scalable system design, database architecture, API development, cloud infrastructure |
| `engineering-security-engineer.md` | Threat modeling, vulnerability assessment, secure code review, security architecture |
| `engineering-database-optimizer.md` | Schema design, query optimization, indexing strategies, performance tuning (PostgreSQL, MySQL, etc.) |
| `engineering-devops-automator.md` | Infrastructure automation, CI/CD pipelines, cloud operations |
| `engineering-sre.md` | SLOs, error budgets, observability, chaos engineering, toil reduction |
| `engineering-ai-engineer.md` | ML model development, deployment, AI-powered applications, data pipelines |
| `engineering-mobile-app-builder.md` | Native iOS/Android and cross-platform mobile development |
| `engineering-technical-writer.md` | Developer docs, API references, READMEs, tutorials |
| `engineering-data-engineer.md` | Data pipelines, lakehouse architectures, ETL/ELT, Spark, dbt, streaming |
| `engineering-git-workflow-master.md` | Git workflows, branching strategies, conventional commits, rebasing |
| `engineering-rapid-prototyper.md` | Ultra-fast proof-of-concept and MVP creation |
| `engineering-incident-response-commander.md` | Production incident management, response coordination, post-mortems |
| `engineering-embedded-firmware-engineer.md` | Embedded systems and firmware development |
| `engineering-solidity-smart-contract-engineer.md` | Solidity smart contracts, blockchain development |
| `engineering-threat-detection-engineer.md` | Security threat detection and monitoring |
| `engineering-autonomous-optimization-architect.md` | Autonomous system optimization |
| `engineering-ai-data-remediation-engineer.md` | AI data quality and remediation |
| `engineering-feishu-integration-developer.md` | Feishu/Lark integration development |
| `engineering-wechat-mini-program-developer.md` | WeChat Mini Program development |

#### product/

| File | Description |
|------|-------------|
| `product-manager.md` | Full product lifecycle — discovery, strategy, roadmap, stakeholder alignment, GTM, outcome measurement |
| `product-feedback-synthesizer.md` | Collecting and synthesizing user feedback into actionable product insights |
| `product-sprint-prioritizer.md` | Sprint planning, feature prioritization, resource allocation, data-driven frameworks |
| `product-trend-researcher.md` | Market intelligence, emerging trends, competitive analysis, opportunity assessment |
| `product-behavioral-nudge-engine.md` | Behavioral design and nudge strategies |

#### design/

| File | Description |
|------|-------------|
| `design-ui-designer.md` | Visual design systems, component libraries, pixel-perfect interfaces |
| `design-ux-architect.md` | Technical architecture and UX, CSS systems, implementation guidance |
| `design-ux-researcher.md` | User behavior analysis, usability testing, data-driven design insights |
| `design-brand-guardian.md` | Brand identity, consistency, strategic positioning |
| `design-image-prompt-engineer.md` | AI image prompt engineering |
| `design-visual-storyteller.md` | Visual narrative and storytelling |
| `design-inclusive-visuals-specialist.md` | Inclusive and accessible visual design |
| `design-whimsy-injector.md` | Delight and personality in UI/UX |

#### testing/

| File | Description |
|------|-------------|
| `testing-api-tester.md` | API validation, performance testing, QA across systems and integrations |
| `testing-performance-benchmarker.md` | System performance measurement, analysis, optimization |
| `testing-accessibility-auditor.md` | WCAG audits, assistive technology testing, inclusive design |
| `testing-evidence-collector.md` | Screenshot-based QA, visual proof collection |
| `testing-reality-checker.md` | Reality validation and fact-checking |
| `testing-test-results-analyzer.md` | Test result analysis and reporting |
| `testing-tool-evaluator.md` | Tool and technology evaluation |
| `testing-workflow-optimizer.md` | Testing workflow optimization |

#### project-management/

| File | Description |
|------|-------------|
| `project-manager-senior.md` | Specs to tasks, realistic scope, exact requirements |
| `project-management-project-shepherd.md` | Cross-functional coordination, timeline management, stakeholder alignment |
| `project-management-jira-workflow-steward.md` | Jira workflow management |
| `project-management-experiment-tracker.md` | Experiment tracking and analysis |
| `project-management-studio-operations.md` | Studio operations management |
| `project-management-studio-producer.md` | Studio production management |

#### support/

| File | Description |
|------|-------------|
| `support-support-responder.md` | Customer support, issue resolution, multi-channel support |
| `support-analytics-reporter.md` | Support analytics and reporting |
| `support-finance-tracker.md` | Financial tracking and reporting |
| `support-infrastructure-maintainer.md` | System reliability, performance optimization, technical operations |
| `support-legal-compliance-checker.md` | Legal compliance checking |
| `support-executive-summary-generator.md` | Executive summary generation |

#### marketing/

| File | Description |
|------|-------------|
| `marketing-content-creator.md` | Multi-platform content strategy, editorial calendars, brand storytelling |
| `marketing-growth-hacker.md` | Rapid user acquisition, viral loops, conversion funnels |
| `marketing-seo-specialist.md` | Technical SEO, content optimization, organic search growth |
| `marketing-social-media-strategist.md` | Social media strategy |
| `marketing-linkedin-content-creator.md` | LinkedIn content strategy |
| `marketing-podcast-strategist.md` | Podcast strategy |
| `marketing-reddit-community-builder.md` | Reddit community building |
| `marketing-tiktok-strategist.md` | TikTok content strategy |
| `marketing-twitter-engager.md` | Twitter engagement strategy |
| `marketing-instagram-curator.md` | Instagram curation |
| `marketing-book-co-author.md` | Book co-authoring |
| `marketing-ai-citation-strategist.md` | AI citation strategy |
| `marketing-app-store-optimizer.md` | App store optimization |
| `marketing-carousel-growth-engine.md` | Carousel growth strategy |
| `marketing-short-video-editing-coach.md` | Short video editing coaching |
| *(+ regional specialists)* | douyin, kuaishou, xiaohongshu, weibo, zhihu, baidu, bilibili, wechat |

#### sales/

| File | Description |
|------|-------------|
| `sales-engineer.md` | Pre-sales engineering, technical discovery, demos, POC scoping |
| `sales-coach.md` | Rep development, pipeline review, call coaching, deal strategy |
| `sales-deal-strategist.md` | Deal strategy |
| `sales-discovery-coach.md` | Discovery coaching |
| `sales-outbound-strategist.md` | Outbound strategy |
| `sales-pipeline-analyst.md` | Pipeline analysis |
| `sales-account-strategist.md` | Account strategy |
| `sales-proposal-strategist.md` | Proposal strategy |

#### specialized/

| File | Description |
|------|-------------|
| `specialized-mcp-builder.md` | MCP server development — custom tools, resources, prompts |
| `specialized-workflow-architect.md` | Complete workflow trees, branch conditions, failure modes, handoff contracts |
| `specialized-developer-advocate.md` | Developer communities, DX optimization, platform adoption |
| `specialized-document-generator.md` | PDF, PPTX, DOCX, XLSX generation |
| `specialized-salesforce-architect.md` | Salesforce multi-cloud design, integration patterns |
| `specialized-model-qa.md` | AI model QA |
| `compliance-auditor.md` | SOC 2, ISO 27001, HIPAA, PCI-DSS compliance |
| `agents-orchestrator.md` | Multi-agent workflow orchestration |
| *(+ more)* | recruitment-specialist, supply-chain-strategist, blockchain-security-auditor, etc. |

#### game-development/

| File | Description |
|------|-------------|
| `game-designer.md` | Game design |
| `game-audio-engineer.md` | Game audio engineering |
| `level-designer.md` | Level design |
| `narrative-designer.md` | Narrative design |
| `technical-artist.md` | Technical art |
| *(+ engine-specific)* | godot/, unity/, unreal-engine/, roblox-studio/, blender/ |

#### spatial-computing/

| File | Description |
|------|-------------|
| `visionos-spatial-engineer.md` | visionOS spatial computing |
| `xr-immersive-developer.md` | XR immersive development |
| `xr-interface-architect.md` | XR interface architecture |
| `macos-spatial-metal-engineer.md` | macOS spatial Metal engineering |
| `terminal-integration-specialist.md` | Terminal integration for spatial computing |
| `xr-cockpit-interaction-specialist.md` | XR cockpit interaction design |

#### academic/

| File | Description |
|------|-------------|
| `academic-anthropologist.md` | Anthropological analysis and cultural research |
| `academic-geographer.md` | Geographic and spatial analysis |
| `academic-historian.md` | Historical research and analysis |
| `academic-narratologist.md` | Narrative structure and storytelling analysis |
| `academic-psychologist.md` | Psychological analysis and behavioral insights |

#### paid-media/

| File | Description |
|------|-------------|
| `paid-media-auditor.md` | Paid media account auditing |
| `paid-media-creative-strategist.md` | Ad creative strategy and optimization |
| `paid-media-paid-social-strategist.md` | Paid social media campaign strategy |
| `paid-media-ppc-strategist.md` | PPC campaign management and optimization |
| `paid-media-programmatic-buyer.md` | Programmatic ad buying |
| `paid-media-search-query-analyst.md` | Search query analysis and keyword strategy |
| `paid-media-tracking-specialist.md` | Ad tracking and attribution |

> **Note:** This catalog is a snapshot. The [agency-agents repo](https://github.com/msitarzewski/agency-agents) is actively maintained and may have new agents not listed here. If you need a specialty not found in this catalog, browse the repo directly.

### Required Agent Structure

Every tailored agent must have these sections (matching agency-agents format):

1. **Persona** — one-line identity with personality and expertise level
2. **Philosophy** — 3-5 operating principles specific to this role AND this project's stack
3. **Stack Expertise** — deep knowledge of THIS project's technologies and their interactions, edge cases, common pitfalls
4. **Process** — specific workflow steps using the project's actual commands
5. **Success Metrics** — measurable criteria (e.g., "zero type errors", "100% lint pass", "all tests green")
6. **Deliverables** — concrete outputs this agent produces
7. **Communication Style** — how the agent presents findings and results

### Tailoring Process

When you fetch an agent from agency-agents, adapt it:

1. **Keep:** The overall structure, persona voice, philosophy principles, communication style
2. **Replace:** Generic framework advice → project-specific stack-intersection knowledge from Phase 1
3. **Add:** Actual file paths, directories, commands, patterns found during scan
4. **Add:** Success metrics using the project's real tools (not generic "run tests" — specific `npm test` or `go test ./...`)
5. **Add:** Workflow connections to commands and skills from Layers 2-3
6. **Remove:** Any content that doesn't apply to this project's detected stack

### Quality Criteria

- [ ] Agent was **fetched from agency-agents via `curl -s`** (not WebFetch, not composed from scratch unless curl failed)
- [ ] Agent has **all 7 required sections** — if the fetched original has additional sections, keep them
- [ ] Agent is **at least 80 lines** — agency-agents originals are 200-400 lines; tailored versions must preserve substantial depth
- [ ] **Stack Expertise is the longest section** — this is where project-specific knowledge lives (at least 5 project-specific bullet points)
- [ ] Stack expertise references specific files, directories, and patterns from Phase 1
- [ ] Process uses the project's actual commands (not generic)
- [ ] Success metrics are measurable with the project's actual tools
- [ ] **Specificity test:** Remove the project name — can you still identify which stack this targets?
- [ ] **Connection check:** Agent references skills it follows and commands it complements

### Frontmatter Reference

| Field | Required | Values |
|-------|----------|--------|
| `description` | Yes | One-line description |
| `model` | Yes | `sonnet` (default), `opus` (for architect) |
| `allowed-tools` | Yes | Comma-separated tool list |
| `isolation` | No | `worktree` for agents that write code |

### Fallback (only when curl actually fails)

Only if `curl` returns an error or empty content after you attempt the fetch, compose agents from scratch following the 7-section structure above. You must still meet the minimum 80-line depth and all quality criteria. Do NOT use this fallback to save tokens — always attempt `curl` first.

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

## 9.7 Output Requirements

These are **hard requirements**, not suggestions. If a detection matches, you MUST generate the corresponding outputs. Never skip a required output — if the content feels generic, refine it until it's specific rather than deleting it.

### Always Generate (every project, no exceptions)

| Output | Category |
|--------|----------|
| `CLAUDE.md` | Project documentation |
| `INSTRUCTION.md` | Onboarding guide |
| `commit`, `implement`, `fix`, `review` | Commands |
| `implement-feature`, `fix-bug`, `improve-architecture` (each with `evals/evals.json`) | Skills |
| `architect`, `product-manager`, `code-reviewer` agents | Agents |

### Generate When Detected (mandatory — if detection matches, GENERATE it)

| When You Detect... | You MUST Generate... |
|---------------------|----------------------|
| Styling framework | `design-system` skill |
| Backend framework | `api-patterns` skill, `security-audit` command, `security-engineer` agent, `backend-architect` agent |
| Database / ORM | `schema-patterns` skill, `optimize-db` command, `database-optimizer` agent |
| Test framework | `tdd` skill, `api-tester` agent |
| Test framework AND linter | `developer` agent (worktree) |
| Frontend framework | `frontend-developer` agent |
| Docker OR CI/CD | `devops-automator` agent |
| ML/AI dependencies | `ai-engineer` agent |
| Mobile (RN/Flutter/Swift) | `mobile-app-builder` agent |
| Linter installed | lint pre-commit hook |
| Linter + fast tests | lint + test pre-commit hook |
| Framework with docs | Context7 MCP server |

### Enforce Minimum, Reason Beyond

- The tables above define the **minimum** outputs. Generate all that match.
- If the project's unique stack suggests ADDITIONAL agents or skills not listed here, generate those too.
- **Never skip a detection-triggered output.** If the content feels generic, refine it until it embeds project-specific knowledge — do not delete it.
- Browse the [agency-agents catalog](https://github.com/msitarzewski/agency-agents) for additional agents that would benefit this project beyond the minimum.

---

## 9.8 Workflow Connections

Generated outputs should form a connected pipeline, not isolated files. When a developer uses your generated config, they should experience a coherent workflow where commands, agents, skills, and hooks reference each other.

### The Pipeline

```
User runs /implement command
  → Command suggests: "invoke the developer agent for worktree isolation"
  → Developer agent follows: implement-feature skill methodology
  → Agent validates with: same lint/test commands as CLAUDE.md
  → On commit: pre-commit hook runs the same lint command
```

### Connection Rules

When composing each layer, build explicit connections to other layers **that were actually generated**. Only reference entities that exist — if no `developer` agent was generated, don't reference it from commands.

| Layer | Should Reference (when the target exists) |
|-------|------------------------------------------|
| Commands | Which agent handles the same workflow in isolation (e.g., "invoke `developer` agent for worktree") |
| Skills | Which agent(s) apply this methodology (e.g., "The `developer` agent follows this methodology") |
| Agents | Which skill(s) inform their approach and which commands they complement (e.g., "Follows `implement-feature` skill methodology") |
| Hooks | Same lint/test commands documented in CLAUDE.md |

### Example Connections for a Next.js + Prisma Project

- `/implement` command → "For isolated implementation, invoke the `developer` agent"
- `/review` command → "For deep review in separate context, invoke the `reviewer` agent"
- `implement-feature` skill → "The `developer` agent applies this methodology in a worktree"
- `developer` agent → "Follows the methodology in `implement-feature` skill. Complements the `/implement` command with worktree isolation"
- `reviewer` agent → "Complements `/review` command with deeper analysis in separate context"
- pre-commit hook → runs `npm run lint` (same command as CLAUDE.md and commit command)

### Why This Matters

Without connections, a developer doesn't know that `/implement` and the `developer` agent are related — they seem like duplicates. With connections, it's clear: `/implement` runs inline, the `developer` agent runs in a worktree. The skill teaches the methodology both follow.

---

## 9.9 Composition Process

How to compose each output. Follow this process for every file you generate. Generation happens per-layer (CLAUDE.md → Commands → Skills → Agents → Hooks/MCP → INSTRUCTION.md), with self-review after each layer before moving to the next.

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

## 9.10 Edge Cases and Fallbacks

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

## 9.11 Quality Validation Checklist

Run this checklist after generating all outputs, before presenting to the user.

### Per-File Checks

For each generated file:

- [ ] **No placeholders remaining** — no `{{ }}`, no `TODO`, no `[FILL IN]`
- [ ] **Uses real commands** — every shell command was detected in Phase 1, not assumed
- [ ] **Stack-specific content** — contains knowledge unique to this project's technology combination
- [ ] **Correct file path** — placed in the right directory (`.claude/commands/`, `.claude/skills/<name>/`, `.claude/agents/`)
- [ ] **Valid frontmatter** — YAML frontmatter has all required fields
- [ ] **Agent depth check** — each agent file is at least 80 lines with all 7 required sections
- [ ] **Agent source check** — agents were fetched from agency-agents via `curl -s` (not WebFetch, not composed from scratch unless curl failed)
- [ ] **Skill description check** — each skill description is ~100 words with 5+ action-verb trigger phrases
- [ ] **Skill evals check** — each skill has `evals/evals.json` with 2-3 test prompts and discriminating assertions
- [ ] **Skill size check** — each SKILL.md is under 500 lines

### Cross-File Checks

- [ ] **No contradictions** — CLAUDE.md commands match what's in `.claude/commands/`
- [ ] **Consistent tool references** — if CLAUDE.md says `npm test`, agents/commands also say `npm test` (not `npx jest`)
- [ ] **No duplicate content** — skills don't repeat what's in CLAUDE.md; agents don't repeat what's in skills
- [ ] **Hooks use validated commands** — hook commands were confirmed installed (Phase 1 should have run `command -v`)
- [ ] **Workflow connections present** — commands reference agents, agents reference skills, skills reference agents (per section 9.8, only for entities that were actually generated)

### Completeness Checks (hard requirements — fail if missing)

- [ ] **CLAUDE.md generated** — always required, no exceptions
- [ ] **INSTRUCTION.md generated** — always required (unless one already exists)
- [ ] **Universal commands generated** — commit, implement, fix, review — all four must exist
- [ ] **Universal skills generated** — implement-feature, fix-bug, improve-architecture — all three must exist
- [ ] **Universal agents generated** — architect, product-manager, code-reviewer — all three must exist
- [ ] **Detection-triggered outputs exist** — for EVERY detection in Phase 1, check the mapping in section 9.7:
  - Frontend framework detected → frontend-developer agent EXISTS, design-system skill EXISTS
  - Backend framework detected → backend-architect agent EXISTS, security-engineer agent EXISTS, api-patterns skill EXISTS, security-audit command EXISTS
  - Database/ORM detected → database-optimizer agent EXISTS, schema-patterns skill EXISTS, optimize-db command EXISTS
  - Test framework detected → api-tester agent EXISTS, tdd skill EXISTS
  - Test + linter detected → developer agent EXISTS
  - Docker/CI detected → devops-automator agent EXISTS
  - Linter installed → lint pre-commit hook EXISTS
- [ ] **No outputs deleted during self-review** — if the self-review found a file too generic, it was REFINED, not deleted

---

## 9.12 Self-Review Criteria

Apply after composing each layer. Read back what was written, check against these criteria, refine until no issues remain, then move to the next layer.

### Per-Layer Review Focus

| Layer | Key Review Questions |
|-------|---------------------|
| CLAUDE.md | Every section traces to Phase 1? Commands are real? Under 200 lines? |
| Commands | Validation steps match CLAUDE.md? Steps use real commands? Links to agents per 9.8? |
| Skills | Description ~100 words and "pushy" with 5+ triggers? WHY-based instructions (not rigid MUSTs)? 2+ Input/Output examples? Under 500 lines? `evals/evals.json` with 2-3 discriminating test prompts? No CLAUDE.md duplication? Links to agents per 9.8? |
| Agents | Stack-intersection knowledge? Consistent with commands + skills? Specificity test? Links to skills + commands per 9.8? |
| Hooks/MCP | Commands match CLAUDE.md? Binary confirmed installed? |

### Areas of Improvement

Ask for each generated file:

- **Stack intersection depth:** Does this output contain knowledge about how detected technologies **interact**? A developer agent for Next.js + Prisma should know that Prisma queries belong in Server Components — not just know React and Prisma separately.
- **Command accuracy:** Does every validation step reference commands that **actually exist** in this project? (Not assumed — verified in Phase 1)
- **Specificity test:** If I replace the project name with "generic-app," does the content still make sense? If yes, it's too generic — **refine it until specific, do NOT delete it.**
- **Completeness:** Is there a detected technology with no corresponding guidance? (e.g., Playwright detected but no E2E methodology in any skill)

### Gaps to Check

- **Workflow gaps:** What does a developer working on this project do daily that has no command/skill/agent support? (e.g., database migrations, deployment, code generation)
- **Agent blind spots:** Does each agent reference the **actual files and directories** found in Phase 1? (e.g., reviewer should know where routes live, not just "check API endpoints")
- **Skill methodology gaps:** Do skills teach methodology for the detected stack's **unique challenges**? (e.g., a tdd skill for a project with both unit and E2E tests should address both)
- **Hook coverage:** If a linter and test framework were both detected and confirmed fast, is a lint+test pre-commit hook generated?

### Anti-Patterns to Eliminate

- Lines like "follow best practices" or "write clean code" — too generic, remove
- Agent sections that list framework features from documentation — replace with project-specific patterns
- Commands with steps the project can't actually run (e.g., "run lint" when no linter detected)
- Skills that duplicate CLAUDE.md content — skills are for methodology, CLAUDE.md is for facts

### Cross-Layer Consistency (after each layer)

Before moving to the next layer, verify consistency with completed layers:

- Commands reference the same tool names as CLAUDE.md
- Skills don't contradict command workflows
- Agents reference commands and patterns documented in earlier layers
- No duplicate content across layers

### When to Stop (per layer)

Stop refining a layer when a review pass finds **zero** issues. Typically 1-2 passes per layer. Then move to the next layer.

---

## 9.13 INSTRUCTION.md Template

After the self-review loop completes and the quality validation checklist passes, produce an `INSTRUCTION.md` in the project root as a quick-start onboarding guide. This is tailored to what was actually generated — not a generic Claude Code tutorial.

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
