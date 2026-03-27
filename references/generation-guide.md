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


## 9.2 Skill Guidelines

All output lives in `.claude/skills/<name>/`. There are three skill types — methodology, workflow, and invocable — but ALL follow the same [Anthropic skill best practices](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md).

### Anthropic Skill Principles (non-negotiable for ALL types)

1. **Description is the trigger** — The `description` field is the PRIMARY mechanism that determines when Claude activates the skill. Write ~100 words that are "a little pushy" — explicitly state WHEN to use this skill with 5+ action-verb trigger phrases. Combat Claude's natural under-triggering tendency by being specific about contexts where the skill applies.

2. **Explain WHY, not just rules** — Appeal to Claude's theory of mind. Instead of rigid MUSTs and all-caps ALWAYS/NEVER, explain the reasoning behind each guideline. Claude follows reasoning better than rote commands.

3. **Lean instructions** — Every section must earn its place. Remove things that aren't pulling weight. If a guideline doesn't change behavior, cut it.

4. **Progressive disclosure** — Keep SKILL.md under 500 lines. Use `references/` subdirectory for larger content the skill can point to.

5. **Concrete examples** — Include at least 2 Input/Output pairs showing the pattern in action with real project code.

6. **No duplication with CLAUDE.md** — Skills teach methodology ("how to approach X"). CLAUDE.md teaches facts ("what tools/commands exist"). Never repeat CLAUDE.md content in a skill.

7. **Evals required** — `evals/evals.json` with 2-3 realistic test prompts + objectively verifiable assertions.

8. **Principle of Lack of Surprise** — A skill's contents must NOT surprise users given the description.

### Skill Structure

```
.claude/skills/<name>/
├── SKILL.md           # Required — instructions + methodology (<500 lines)
├── references/        # Optional — depth docs loaded as needed
└── evals/
    └── evals.json     # Required — 2-3 test prompts + assertions
```

### Frontmatter Reference

| Field | Required | Values |
|-------|----------|--------|
| `name` | Yes | Skill name (kebab-case) |
| `description` | Yes | ~100 words: purpose + 5+ trigger phrases with action verbs. Be pushy. |

### Evals (evals.json)

Every generated skill MUST include `evals/evals.json` with 2-3 realistic test prompts.

```json
[
  {
    "prompt": "What a real developer would type",
    "assertions": [
      "Objectively verifiable assertion 1",
      "Objectively verifiable assertion 2"
    ]
  }
]
```

- Prompts must be realistic — what a developer would actually say
- Assertions must be **objectively verifiable** and **discriminating**
- 2-3 evals per skill is sufficient

### Description Anti-Pattern

**Bad (too short, not pushy):**

```yaml
description: Design system and styling patterns for this project.
```

**Bad (describes WHAT, not WHEN):**

```yaml
description: >
  This skill contains information about the project's UI components,
  Tailwind configuration, and shadcn/ui primitives.
```

**Good (pushy, ~100 words, 5+ trigger phrases):**

```yaml
description: >
  UI component and styling patterns for this React 19 + Tailwind CSS 4 + shadcn/ui
  project. Use this skill when: building new UI components, styling existing components,
  choosing between shadcn primitives and custom components, applying Tailwind utility
  classes, creating responsive layouts, implementing dark mode, picking colors or spacing
  from the theme config, composing dialog or form layouts, reviewing component structure,
  or deciding how to organize component files.
```

---

### 9.2.1 Methodology Skills

Auto-activate based on description triggers. Teach HOW to think about recurring tasks. These now absorb the step-by-step workflow guidance that commands previously provided.

**SKILL.md anatomy:**

```markdown
---
name: skill-name
description: >
  ~100 words. "Use when..." with 5+ action-verb trigger phrases.
---

# Skill Title

## Why This Matters
Brief context on why this methodology exists. Appeal to reasoning.

## Methodology
Step-by-step approach with WHY for each step.

## Examples
At least 2 concrete Input/Output pairs from the actual project.

## Patterns to Follow
Project-specific patterns with file references.

## Anti-Patterns
Common mistakes in this codebase and why they cause problems.

## Agent Reference
Which agent(s) follow this methodology when dispatched.
```

**Always generate:**

- `implement-feature` — structured implementation (explore → plan → implement → validate)
- `fix-bug` — root cause analysis (reproduce → diagnose → fix → verify → prevent)
- `improve-architecture` — architecture improvement (explore → identify → design alternatives → evaluate → recommend)

**Generate when detected (mandatory):**

- `tdd` — when test framework detected
- `design-system` — when styling framework detected
- `api-patterns` — when backend framework detected
- `schema-patterns` — when database/ORM detected

**Quality criteria (in addition to all Anthropic principles):**

- [ ] Instructions explain WHY (theory of mind)
- [ ] At least 2 Input/Output examples from the actual project
- [ ] References which agent(s) follow this methodology

---

### 9.2.2 Workflow Skills

Auto-activate on complex multi-step tasks. Orchestrate named agents through phases with verification gates. Inspired by [mattpocock/skills](https://github.com/mattpocock/skills) (write-a-prd, triage-issue, improve-codebase-architecture) and [superpowers](https://github.com/obra/superpowers) (subagent-driven development, systematic-debugging).

**Workflow skills follow ALL Anthropic principles above** — the fact that they orchestrate agents doesn't exempt them from description quality, progressive disclosure, or lean instructions.

**SKILL.md anatomy:**

```markdown
---
name: workflow-name
description: >
  ~100 words. "Use when..." with 5+ trigger phrases.
  Mention that it orchestrates agents for multi-step work.
---

# Workflow Title

## Why This Workflow
Why ad-hoc execution misses what this workflow catches.

## Workflow

### Phase 1: [Name]
Steps with verification gate before next phase.

### Phase 2: [Name] (dispatch [agent-name] agent)
- Dispatch `agent-name` agent with complete task description
- Agent follows `methodology-skill` for domain expertise
- Verification: [what must be true before proceeding]

### Phase 3: [Name] (dispatch [agent-name] agent)
- Two-stage review: spec compliance first, then code quality
- If issues found → dispatch agent to fix → re-review

### Phase N: Finalize
Run tests, commit, summarize.

## Agent Dispatch Reference

| Phase | Agent | Purpose |
|-------|-------|---------|
| 2 | agent-name | What it does |
| 3 | agent-name | What it does |

## Common Mistakes
Document rationalization patterns — how agents skip steps and why it matters.
```

**Key structural patterns:**

- **Vertical slices** — each increment cuts through ALL layers end-to-end (schema → API → UI → tests), not horizontal layers. Independently demoable.
- **Agent dispatch by name** — "Dispatch `developer` agent with complete task description." Use exact agent names from `.claude/agents/`.
- **Two-stage review** — spec compliance first (does it match the plan?), then code quality.
- **Verification gates** — explicit checkpoints between phases.
- **User validation checkpoints** — present plan to user before proceeding. Resolve decision dependencies one-by-one.
- **Common Mistakes section** — anti-rationalization. Document how agents shortcut or skip steps.
- **Minimal questioning for execution** — execution-oriented phases minimize user interaction.
- **Durable artifacts** — generated artifacts (plans, issues) avoid file paths, line numbers, code snippets. Describe behaviors and contracts instead.

**Workflow skill catalog (all by judgment, none mandatory):**

| Skill | When to Consider | Agents Dispatched |
|-------|------------------|-------------------|
| `feature-development` | Multi-layer feature work | developer, code-reviewer |
| `bug-fix-lifecycle` | Bug investigation + fix | developer, code-reviewer |
| `code-review-fix` | Review + fix cycle | code-reviewer, developer |
| `systematic-debugging` | Deep debugging (test framework) | developer |
| `security-audit-workflow` | Security scan + fix (backend) | security-engineer, developer |
| `db-optimization-workflow` | DB perf analysis (database) | database-specialist, developer |
| `refactoring-workflow` | Architectural refactor | architect, developer, code-reviewer |
| `onboarding-workflow` | Codebase understanding | architect |
| `migration-workflow` | Framework/lib upgrade | developer, code-reviewer |
| `pr-workflow` | Prepare + review + PR | code-reviewer, developer |

Model selects which workflow skills to generate based on scan results + judgment. If zero workflow skills are appropriate (e.g., trivial config-only repo), justify in Phase 3.

**Quality criteria (in addition to all Anthropic principles):**

- [ ] Phases are sequential with verification gates
- [ ] Agent dispatch table present with exact agent names
- [ ] Common Mistakes section documents rationalization patterns
- [ ] Workflow skills dispatch only agents that are actually generated in Layer 3
- [ ] Vertical slices used (not horizontal layers) where applicable
- [ ] User validation checkpoints before irreversible steps

#### Example: feature-development workflow skill

`````markdown
---
name: feature-development
description: >
  Use when implementing a new feature end-to-end that spans multiple layers.
  Activates on "build this feature", "implement end-to-end", "add this capability",
  "create a new feature across model/service/API/UI", "implement this from scratch".
  Orchestrates planning with vertical slices, agent-delegated implementation,
  two-stage code review, and finalization. Dispatches developer and code-reviewer
  agents by name.
---

# Feature Development Workflow

## Why This Workflow

Building features across multiple layers (model → service → API → UI) requires
coordination that ad-hoc implementation misses. Vertical slices ensure each
increment is independently demoable. Agent delegation keeps implementation
focused while two-stage review catches both spec drift and code quality issues.

## Workflow

### Phase 1: Understand & Plan

- Read related source files to understand current patterns
- Break feature into vertical slices — each cuts through ALL layers end-to-end
- A good slice: schema change → service method → API endpoint → UI component → test
- Present plan to user. Resolve decision dependencies one-by-one before proceeding

### Phase 2: Implement (dispatch developer agent)

For each vertical slice:

- Dispatch `developer` agent with complete slice description
- Agent follows `implement-feature` methodology skill
- Agent runs lint + tests before completing each slice
- Each slice must leave the codebase in a working state

### Phase 3: Review (dispatch code-reviewer agent)

- Dispatch `code-reviewer` agent on all changes
- **Stage 1:** Spec compliance — does implementation match the plan?
- **Stage 2:** Code quality — patterns, security, performance
- If issues found → dispatch `developer` agent to fix → re-review

### Phase 4: Finalize

- Run full test suite
- Commit with conventional message
- Summarize what changed and why

## Agent Dispatch Reference

| Phase | Agent | Purpose |
|-------|-------|---------|
| 2 | developer | Implement each vertical slice in worktree |
| 3 | code-reviewer | Two-stage review (spec + quality) |
| 3 (fix) | developer | Fix review issues |

## Common Mistakes

- Implementing horizontal layers (all models, then all services) instead of vertical slices
- Skipping the plan phase and jumping straight to code
- Not re-reviewing after fixes — the fix itself may introduce issues
- Making slices too thick — each should be independently demoable
`````

---

### 9.2.3 Invocable Skills

User-invocable via `/skill-name`. These replace what commands previously provided — step-by-step guided workflows that users explicitly trigger. They use the same SKILL.md format with proper frontmatter.

**SKILL.md anatomy:**

```markdown
---
name: skill-name
description: >
  ~100 words. "Use when..." with trigger phrases.
---

# Skill Title

Step-by-step workflow with project-specific validation commands.
Each step uses actual commands detected in Phase 1.
```

**Always generate:**

- `commit` — guided git commit workflow tailored to the project's conventions

**Conditional:**

- `review` — when git detected (code review checklist)
- Others by judgment based on project needs

#### Example: commit invocable skill for a TypeScript + ESLint + Conventional Commits project

`````markdown
---
name: commit
description: >
  Use when creating a git commit, staging changes, or saving work to version
  control. Activates on "commit", "stage changes", "save my work", "create a
  commit", "push my changes". Guides through reviewing changes, running lint,
  writing conventional commit messages, and executing the commit.
---

# Guided Commit

1. Run `git status` and `git diff --staged` to review changes.
2. If nothing is staged, show unstaged changes and ask what to stage.
3. Run `npm run lint` before committing. If it fails, show errors and ask to fix or skip.
4. Write a commit message following conventional commits (lowercase, imperative mood).
5. Run `git commit` with the message.
6. Show the commit hash and summary.
`````

**Quality criteria (in addition to all Anthropic principles):**

- [ ] Every validation step uses a real command from Phase 1
- [ ] Commit skill embeds the project's actual commit conventions
- [ ] No generic advice that applies to any project

---

## 9.4 Agent Guidelines: Fetch & Tailor from agency-agents

> **NON-NEGOTIABLE:** Every agent MUST be downloaded from the agency-agents repository via `curl -s` before any agent file is written. Composing agents from scratch (without fetching) is a quality failure — the fetched templates contain 200-400 lines of production expertise that cannot be replicated by writing from memory. The ONLY exception is when curl returns a 404 or empty response for a specific agent.

Agents are `.md` files in `.claude/agents/`. They are sourced from the [agency-agents](https://github.com/msitarzewski/agency-agents) repository (144+ production-quality agent definitions) and **tailored** to the specific project using Phase 1 scan results.

### Fetch Source

Base URL: `https://raw.githubusercontent.com/msitarzewski/agency-agents/main/`

**CRITICAL:** Use `curl -s` via **Bash** to fetch agents. Do NOT use WebFetch or Fetch tools — they process content through an AI model and return a summary, not the raw markdown file. You need the exact raw content to write as-is.

```bash
# Correct — raw content via curl
curl -s https://raw.githubusercontent.com/msitarzewski/agency-agents/main/engineering/engineering-security-engineer.md

# WRONG — do NOT use these (they return AI-processed summaries)
# WebFetch(url)
# Fetch(url)
```

### Mandatory Fetch-First Workflow

1. **Fetch ALL selected agents via parallel curl, redirecting each to `/tmp/agent-{name}.md`** — batch all curl calls in a single Bash invocation with `&` and `wait`
2. **Verify each file contains valid markdown** — run `head -1 /tmp/agent-*.md` and confirm each starts with `---` (YAML frontmatter), not "404: Not Found"
3. **Read each `/tmp/agent-{name}.md`**, prepend Claude Code frontmatter, and **Write to `.claude/agents/{name}.md`** — then tailor in-place with Edit
4. **Only agents where curl returned 404/empty** may be composed from scratch

### Detection → Agent Mapping (Recommendations, Not Requirements)

Use this table as a starting point for agent selection. **No agent is mandatory** — select only the agents that genuinely benefit this specific project based on Phase 1 scan results and your judgment.

| When You Detect... | Recommended Agent | File Path |
|---------------------|------------|-----------|
| Complex architecture / multi-service | Software Architect | `engineering/engineering-software-architect.md` |
| Active development with PRs | Code Reviewer | `engineering/engineering-code-reviewer.md` |
| Product with multiple user personas | Product Manager | `product/product-manager.md` |
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

**Selection guidance:**

- A small single-purpose library may need only 0-2 agents (e.g., code-reviewer)
- A full-stack app typically benefits from 3-5 agents
- A large monorepo with multiple teams may warrant 5-8+ agents
- If zero agents are appropriate (e.g., trivial config-only repo), justify in Phase 3

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

### Fallback (ONLY for individual agents where curl returned 404/empty)

Only if `curl` returns a 404 or empty content for a **specific** agent, compose that one agent from scratch following the 7-section structure above. You must still meet the minimum 80-line depth and all quality criteria. If curl returned valid content for an agent, you MUST use that content — do not discard it and write from scratch.

**Self-check:** If you are writing ALL agents from scratch, something went wrong — go back to Step 2 and run the curl commands. The most commonly used agents (architect, product-manager, code-reviewer, security-engineer, database-optimizer) all exist in the repo and will succeed.

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
| `implement-feature`, `fix-bug`, `improve-architecture` (each with `evals/evals.json`) | Methodology skills |
| `commit` | Invocable skill |

### Generate When Detected (skills, hooks, MCP)

| When You Detect... | Generate... |
|---------------------|----------------------|
| Styling framework | `design-system` methodology skill |
| Backend framework | `api-patterns` methodology skill |
| Database / ORM | `schema-patterns` methodology skill |
| Test framework | `tdd` methodology skill |
| Git detected | `review` invocable skill |
| Linter installed | lint pre-commit hook |
| Linter + fast tests | lint + test pre-commit hook |
| Framework with docs | Context7 MCP server |

### Workflow Skills (selection by judgment, not by rule)

**No workflow skills are mandatory.** Select based on Phase 1 scan results + judgment. Use the catalog in section 9.2.2 as recommendations. If zero workflow skills are appropriate (e.g., trivial config-only repo), justify in Phase 3.

**Guidance:**

- A small library may need 0 workflow skills
- A typical web app benefits from 1-3 workflow skills (e.g., feature-development, bug-fix-lifecycle)
- A large complex system may warrant 3-5+ workflow skills

### Agents (selection by judgment, not by rule)

**No agents are mandatory.** Select agents based on Phase 1 scan results combined with your judgment about what the project actually needs. Use the Detection → Agent Mapping table in section 9.4 as recommendations. Also ensure agents referenced by workflow skills are generated.

**Guidance:**

- A small library or config-only repo may need 0-2 agents
- A typical web app benefits from 3-5 agents
- A large monorepo or complex system may warrant 5-8+ agents
- If you generate zero agents, you MUST justify this in Phase 3

### Reason Beyond the Tables

- The tables above define the **minimum** for methodology skills, invocable skills, hooks, and MCP. Generate all that match.
- For workflow skills and agents, use judgment to add, skip, or substitute based on project context.
- If the project's unique stack suggests ADDITIONAL skills or agents not listed here, generate those too.
- Browse the [agency-agents catalog](https://github.com/msitarzewski/agency-agents) for additional agents that would benefit this project.

---

## 9.8 Workflow Connections

Generated outputs should form a connected pipeline, not isolated files. When a developer uses your generated config, they should experience a coherent workflow where skills, agents, and hooks reference each other.

### The Pipeline

```
User describes complex task
  → Claude activates: workflow skill (e.g., feature-development)
  → Workflow skill follows: methodology skills (implement-feature, tdd)
  → Workflow skill dispatches: agents (developer, code-reviewer) by name
  → Agents follow: methodology skills for domain expertise
  → Result validated against: CLAUDE.md conventions
  → On commit: pre-commit hook runs the same lint command

User wants explicit action
  → User invokes: /commit (invocable skill)
  → Skill guides: staged changes → lint → conventional message → commit
```

### Connection Rules

When composing each layer, build explicit connections to other layers **that were actually generated**. Only reference entities that exist — if no `developer` agent was generated, don't reference it from skills.

| Layer | Should Reference (when the target exists) |
|-------|------------------------------------------|
| Methodology skills | Which agent(s) follow this methodology (e.g., "The `developer` agent follows this methodology") |
| Workflow skills | Which agents they dispatch by name + which methodology skills agents follow |
| Invocable skills | Same lint/test/build commands as CLAUDE.md |
| Agents | Which methodology skill(s) inform their approach and which workflow skill(s) dispatch them |
| Hooks | Same lint/test commands documented in CLAUDE.md |

### Example Connections for a Next.js + Prisma Project

- `feature-development` workflow skill → "Phase 2: Dispatch `developer` agent. Phase 3: Dispatch `code-reviewer` agent"
- `implement-feature` methodology skill → "The `developer` agent applies this methodology in a worktree"
- `developer` agent → "Follows `implement-feature` skill methodology. Dispatched by `feature-development` and `bug-fix-lifecycle` workflow skills"
- `code-reviewer` agent → "Dispatched by `feature-development` and `code-review-fix` workflow skills for two-stage review"
- `/commit` invocable skill → runs `npm run lint` (same command as CLAUDE.md)
- pre-commit hook → runs `npm run lint` (same command as CLAUDE.md and commit skill)

### Why This Matters

Without connections, a developer doesn't know how workflow skills, methodology skills, and agents relate — they seem like duplicates. With connections, it's clear: the workflow skill orchestrates, the methodology skill teaches HOW, and the agent executes in isolation.

---

## 9.9 Composition Process

How to compose each output. Follow this process for every file you generate. Generation happens per-layer (CLAUDE.md → Skills → Agents → Hooks/MCP → INSTRUCTION.md), with self-review after each layer before moving to the next.

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

- Skip: `tdd` skill, `developer` agent (requires tests for validation)
- Keep: `implement-feature` and `fix-bug` methodology skills — but remove all "run tests" steps
- The `code-reviewer` agent can still be generated if a linter exists

### Project With No Linter

- Skip: lint pre-commit hook, lint+test pre-commit hook
- Remove all "run lint" steps from skills
- The `code-reviewer` agent can still be generated if tests exist

### New Project (No Git History)

- Phase 1.6 (git analysis) returns empty — this is normal
- Skip: git conventions section in CLAUDE.md (no commit history to infer from)
- Commit invocable skill: use a sensible default ("conventional commits, lowercase, imperative mood") but note it's a suggestion, not a detected convention

### Monorepo

- CLAUDE.md: include the Workspace Structure table with each package's path and purpose
- Skills: scope methodology to the workspace being worked on. Validation steps should target the relevant workspace (e.g., `cd packages/web && npm run lint`)
- Agents: the `developer` agent should know the workspace layout and which package to work in
- Consider generating: workspace-specific skills if packages have significantly different stacks (e.g., Python backend + React frontend)

### Multiple Databases

- If both PostgreSQL and Redis are detected, the `db-specialist` agent should cover both
- `schema-patterns` skill should focus on the primary relational DB, with a note about cache patterns if Redis is detected

### Library (No Web/API Framework)

- Skip: `api-patterns` skill, frontend-specific agents
- Focus on: code quality (reviewer), testing, and API design of the library's public interface
- Developer agent should focus on: backward compatibility, type safety, documentation
- Workflow skills: likely only `bug-fix-lifecycle` and possibly `pr-workflow` — skip `feature-development` unless multi-layer

---

## 9.11 Quality Validation Checklist

Run this checklist after generating all outputs, before presenting to the user.

### Per-File Checks

For each generated file:

- [ ] **No placeholders remaining** — no `{{ }}`, no `TODO`, no `[FILL IN]`
- [ ] **Uses real commands** — every shell command was detected in Phase 1, not assumed
- [ ] **Stack-specific content** — contains knowledge unique to this project's technology combination
- [ ] **Correct file path** — placed in the right directory (`.claude/skills/<name>/`, `.claude/agents/`)
- [ ] **Valid frontmatter** — YAML frontmatter has all required fields
- [ ] **Agent depth check** — each agent file is at least 80 lines with all 7 required sections
- [ ] **Agent source check** — EVERY agent was fetched from agency-agents via `curl -s` in Bash (not WebFetch/Fetch, not composed from scratch). If ALL agents were written without curl, this is a hard failure — go back to Layer 4 Step 2 and re-do the fetch
- [ ] **Skill description check** — each skill description is ~100 words with 5+ action-verb trigger phrases
- [ ] **Skill evals check** — each skill has `evals/evals.json` with 2-3 test prompts and discriminating assertions
- [ ] **Skill size check** — each SKILL.md is under 500 lines

### Cross-File Checks

- [ ] **No contradictions** — CLAUDE.md commands match what skills and agents reference
- [ ] **Consistent tool references** — if CLAUDE.md says `npm test`, agents/skills also say `npm test` (not `npx jest`)
- [ ] **No duplicate content** — skills don't repeat what's in CLAUDE.md; agents don't repeat what's in skills
- [ ] **Hooks use validated commands** — hook commands were confirmed installed (Phase 1 should have run `command -v`)
- [ ] **Workflow connections present** — workflow skills dispatch agents, agents reference methodology skills, methodology skills reference agents (per section 9.8, only for entities that were actually generated)
- [ ] **Workflow skill dispatch valid** — every agent name in workflow skill dispatch tables refers to an agent that was actually generated

### Completeness Checks (hard requirements — fail if missing)

- [ ] **CLAUDE.md generated** — always required, no exceptions
- [ ] **INSTRUCTION.md generated** — always required (unless one already exists)
- [ ] **Universal methodology skills generated** — implement-feature, fix-bug, improve-architecture — all three must exist
- [ ] **Invocable skills generated** — commit (always), review (if git detected)
- [ ] **Agents justified** — agents generated match project needs (per Detection → Agent Mapping recommendations in section 9.4). If zero agents were generated, justification is present in Phase 3
- [ ] **Detection-triggered outputs exist** — for EVERY detection in Phase 1, check the mapping in section 9.7:
  - Frontend framework detected → design-system skill EXISTS
  - Backend framework detected → api-patterns skill EXISTS
  - Database/ORM detected → schema-patterns skill EXISTS
  - Test framework detected → tdd skill EXISTS
  - Linter installed → lint pre-commit hook EXISTS
- [ ] **No outputs deleted during self-review** — if the self-review found a file too generic, it was REFINED, not deleted

---

## 9.12 Self-Review Criteria

Apply after composing each layer. Read back what was written, check against these criteria, refine until no issues remain, then move to the next layer.

### Per-Layer Review Focus

| Layer | Key Review Questions |
|-------|---------------------|
| CLAUDE.md | Every section traces to Phase 1? Commands are real? Under 200 lines? |
| Methodology skills | Description ~100 words and "pushy" with 5+ triggers? WHY-based instructions? 2+ I/O examples? Under 500 lines? Evals present? No CLAUDE.md duplication? Links to agents per 9.8? |
| Workflow skills | All methodology skill checks PLUS: phases sequential with verification gates? Agent dispatch table with valid agent names? Common Mistakes section? Vertical slices where applicable? |
| Invocable skills | All methodology skill checks PLUS: every validation step uses real command from CLAUDE.md? |
| Agents | Stack-intersection knowledge? Consistent with skills? Specificity test? Links to methodology + workflow skills per 9.8? |
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
- Skills with steps the project can't actually run (e.g., "run lint" when no linter detected)
- Skills that duplicate CLAUDE.md content — skills are for methodology, CLAUDE.md is for facts
- Workflow skills that dispatch agents not generated in Layer 3 — verify every agent name exists

### Cross-Layer Consistency (after each layer)

Before moving to the next layer, verify consistency with completed layers:

- Skills reference the same tool names as CLAUDE.md
- Workflow skills don't contradict methodology skill approaches
- Agents reference skills and patterns documented in earlier layers
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

{{ if skills_generated }}

## Your Skills

{{ if invocable_skills }}

### Invocable Skills (user-triggered)

| Skill | What it does | Try it |
|-------|-------------|--------|
{{ for each invocable_skill }}
| `/{{ skill_name }}` | {{ one_line_description }} | `{{ example_usage }}` |
{{ end }}

{{ end }}

{{ if methodology_skills }}

### Methodology Skills (auto-activate)

These activate automatically when Claude detects relevant context. Just ask naturally.

{{ for each methodology_skill }}
- **{{ skill_name }}** — {{ description }}. Try: "{{ natural_language_trigger }}"
{{ end }}

{{ end }}

{{ if workflow_skills }}

### Workflow Skills (auto-activate on complex tasks)

These orchestrate multi-step work with agent delegation.

{{ for each workflow_skill }}
- **{{ skill_name }}** — {{ description }}
{{ end }}

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
- Add skills in `.claude/skills/` — create a directory with a `SKILL.md` file
{{ if hooks_generated }}
- Review hooks in `.claude/settings.json` — remove any you don't want
{{ end }}
`````

---

## 9.14 Self-Improvement Scoring Rubric

Quantitative evaluation of all generated outputs as a holistic system. Used during the Holistic Self-Improvement Loop at the end of Phase 2 (after all per-layer self-reviews are complete).

**Rules:**

- Each dimension is scored 0–10. Passing threshold is **8/10 per dimension**.
- Scores must be based on **verification actions** (reading files, counting lines, comparing values) — not impressions.
- If a dimension cannot be evaluated (e.g., no hooks generated → Safety is N/A), score it 10 and note "N/A — not applicable."

---

### Dimension 1: Completeness

**Definition:** All mandatory outputs from section 9.7 are generated. No required file is missing.

**Verification action:** Check every row in the "Always Generate" table and every matching row in "Generate When Detected" table. For agents, verify selection is justified per section 9.4 guidance. Count missing outputs.

| Score | Criteria |
|-------|----------|
| 0 | More than half of mandatory outputs missing |
| 5 | All universal outputs present (CLAUDE.md, 3 methodology skills, commit invocable skill), agents justified, but some detection-triggered outputs missing |
| 10 | Every mandatory output from section 9.7 is present, including all detection-triggered ones, and agent selection matches project needs |

---

### Dimension 2: Specificity

**Definition:** Every line in every generated file traces to a Phase 1 detection. No generic advice.

**Verification action:** For each generated file, read 5 random content lines. For each, identify which Phase 1 detection it traces to. If a line could appear unchanged in any project's config, it fails.

| Score | Criteria |
|-------|----------|
| 0 | Most content is generic framework documentation or boilerplate |
| 5 | Mix of specific and generic — some lines trace to detections, some are filler |
| 10 | Every content line traces to a specific detection. Removing the project name still identifies the stack. |

---

### Dimension 3: Accuracy

**Definition:** Commands are real, file paths exist, versions match detected values.

**Verification action:** For every shell command in generated files (lint, test, build, dev), verify it matches what Phase 1 found. For file paths referenced in skills/agents, verify they were seen during scanning.

| Score | Criteria |
|-------|----------|
| 0 | Multiple commands reference tools not installed or use wrong syntax |
| 5 | Core commands (build, test, lint) are correct but some secondary references are wrong or assumed |
| 10 | Every command, path, and version reference is verified against Phase 1 findings |

---

### Dimension 4: Cross-layer Consistency

**Definition:** No contradictions between layers. Workflow connections verified per section 9.8.

**Verification action:** Check that the lint command in CLAUDE.md = the hook lint command = the lint steps in commands = the lint references in agents. Repeat for test and build commands. Then verify workflow connections: commands reference agents, agents reference skills, skills reference agents.

| Score | Criteria |
|-------|----------|
| 0 | Multiple contradictions — different commands for the same action in different files |
| 5 | Commands are consistent but workflow connections (section 9.8) are missing or broken |
| 10 | Zero contradictions AND all workflow connections from section 9.8 are present and correct |

---

### Dimension 5: Depth

**Definition:** Agents are at least 80 lines with all 7 required sections. Skills teach methodology, not surface-level advice.

**Verification action:** For each agent, count lines and verify all 7 sections exist. Verify Stack Expertise is the longest section. For each skill, verify it teaches methodology specific to the project's stack intersection (not just "follow best practices").

| Score | Criteria |
|-------|----------|
| 0 | Agents are stubs (under 40 lines) or missing sections; skills are generic |
| 5 | Agents meet minimum length but Stack Expertise is thin or generic; skills have some project-specific content |
| 10 | All agents 80+ lines, all 7 sections present, Stack Expertise is the longest section with project-specific patterns. Skills teach deep methodology for the detected stack intersection. |

---

### Dimension 6: Coverage

**Definition:** All stack intersections are captured. No missing tech-pair knowledge.

**Verification action:** List all meaningful 2-way technology pairs from Phase 1 detections (e.g., Next.js+Prisma, React+Tailwind, Jest+React). For each pair, verify at least one generated file contains intersection knowledge about how they work together.

| Score | Criteria |
|-------|----------|
| 0 | Technologies treated in isolation — no intersection knowledge anywhere |
| 5 | Major intersections covered (e.g., framework+ORM) but minor ones missing (e.g., testing+framework) |
| 10 | Every meaningful technology pair has intersection knowledge in at least one generated file |

---

### Dimension 7: Non-redundancy

**Definition:** No duplicate content across layers. Each layer has a distinct role: CLAUDE.md = facts, skills = methodology, agents = persona + deep expertise.

**Verification action:** For each skill, check if any paragraph duplicates content from CLAUDE.md. For each agent, check if Stack Expertise repeats a skill's methodology verbatim. Flag any content that appears in more than one layer.

| Score | Criteria |
|-------|----------|
| 0 | Extensive copy-paste across layers — same paragraphs appear in multiple files |
| 5 | Some thematic overlap but no verbatim duplication; layer roles partially blurred |
| 10 | Zero content duplication. Each file adds unique value. Clear separation: facts → methodology → deep expertise. |

---

### Dimension 8: Actionability

**Definition:** A new developer can immediately use the generated config. Commands are runnable. Skills activate on natural queries. INSTRUCTION.md is a useful onboarding guide.

**Verification action:** Read INSTRUCTION.md — does it list all generated outputs with correct invocation examples? Read each command — are steps concrete and executable (not vague)? Read each skill description — does it contain natural-language triggers matching how a developer would phrase a request?

| Score | Criteria |
|-------|----------|
| 0 | INSTRUCTION.md is a placeholder or missing. Commands have vague steps like "validate the code." |
| 5 | INSTRUCTION.md is present and accurate but missing some outputs. Commands work but some steps lack specificity. |
| 10 | INSTRUCTION.md perfectly summarizes all outputs with working examples. Every command has concrete, executable steps. Every skill has natural activation triggers. |

---

### Dimension 9: Safety

**Definition:** Hooks meet all 3 safety conditions. No destructive defaults. No secrets in generated files.

**Verification action:** For each hook: (1) binary was confirmed installed via `command -v` in Phase 1, (2) command runs in under 30 seconds, (3) disable comment is present in the hook definition. Scan all generated files for `.env` contents or hardcoded secret values.

| Score | Criteria |
|-------|----------|
| 0 | Hooks generated without verifying binary installed, or secrets present in output |
| 5 | Hooks mostly safe but missing disable comments or one condition unchecked |
| 10 | Every hook passes all 3 conditions. No destructive commands. No secrets. Every hook has a disable comment. |

---

### Dimension 10: Freshness

**Definition:** Patterns and references match the actual project state, not stale assumptions or generic framework defaults.

**Verification action:** Pick 3 specific references from generated files (a directory path, a framework version, a script name). Verify each against Phase 1 scan results. Check that no reference assumes a default that differs from what was actually detected.

| Score | Criteria |
|-------|----------|
| 0 | References outdated patterns, directories that don't exist, or assumed framework defaults |
| 5 | Most references are current but some assume defaults rather than using detected values |
| 10 | Every reference matches the actual project state as scanned in Phase 1 |

---

### Quick-Reference Checklist

Use this table during each scoring round:

| # | Dimension | Verify by | Pass (≥8)? |
|---|-----------|-----------|------------|
| 1 | Completeness | Count outputs vs 9.7 tables | |
| 2 | Specificity | Sample 5 lines per file → trace to detections | |
| 3 | Accuracy | Compare commands/paths to Phase 1 | |
| 4 | Cross-layer Consistency | Match commands across layers + check 9.8 connections | |
| 5 | Depth | Count agent lines + check 7 sections + Stack Expertise length | |
| 6 | Coverage | List tech pairs → find intersection knowledge | |
| 7 | Non-redundancy | Check for duplicated content across layers | |
| 8 | Actionability | Read INSTRUCTION.md + command steps + skill triggers | |
| 9 | Safety | Verify hook conditions + scan for secrets | |
| 10 | Freshness | Spot-check 3 references against Phase 1 | |
