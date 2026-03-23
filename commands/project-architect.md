---
description: Analyze your codebase and generate Claude Code configuration (CLAUDE.md, commands, skills, agents, hooks)
allowed-tools: Bash, Read, Write, Grep, Glob
---

# Project Architect

You are a project analysis assistant. Your job is to scan this codebase, understand its stack and conventions, then generate a complete `.claude/` configuration tailored to this project.

> **SAFETY: Do NOT execute project code, run builds, or install dependencies. Only read files.**

---

## Phase 1: Scan the Project

Gather project information using read-only tools. Work through each category below, recording what you find.

### 1.1 Read root config files (highest signal)

Check for and read these files at the project root. Extract the tech stack, dependencies, and versions:

- `package.json` — name, dependencies, devDependencies, scripts, workspaces
- `go.mod` — module path, Go version, dependencies
- `pyproject.toml` — project metadata, dependencies, build system
- `Cargo.toml` — package info, dependencies, workspace members
- `composer.json` — PHP dependencies, autoload config
- `Gemfile` — Ruby dependencies
- `build.gradle` / `build.gradle.kts` — Java/Kotlin dependencies, plugins
- `pom.xml` — Maven dependencies, plugins
- `pubspec.yaml` — Dart/Flutter dependencies
- `mix.exs` — Elixir dependencies
- `Makefile`, `justfile`, `Taskfile.yml` — available task runner targets
- `Dockerfile`, `docker-compose.yml` — containerization
- `deno.json` / `deno.jsonc` — Deno runtime
- `.env.example` — environment variable patterns (do NOT read `.env` — may contain secrets)

Read whichever files exist. Skip the rest silently.

### 1.2 List directory structure

Run: `find . -maxdepth 2 -type d -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/__pycache__/*' -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/.next/*' -not -path '*/target/*'`

Note the top-level directories and what they suggest about the project pattern (monorepo, Go standard layout, typical app structure, library, etc.).

### 1.3 Check for test, linter, and CI/CD configs

Scan for the presence of these files (do not read their full contents unless needed for detection):

**Testing:**
`jest.config.*`, `vitest.config.*`, `pytest.ini`, `pyproject.toml [tool.pytest]`, `.mocharc.*`, `cypress.config.*`, `playwright.config.*`, `phpunit.xml`, `.rspec`, `*_test.go`

**Linting & formatting:**
`.eslintrc*`, `eslint.config.*`, `biome.json`, `.prettierrc*`, `.golangci.yml`, `ruff.toml`, `.rubocop.yml`, `.stylelintrc*`, `.editorconfig`

**CI/CD:**
`.github/workflows/`, `.gitlab-ci.yml`, `.circleci/`, `Jenkinsfile`, `.travis.yml`, `bitbucket-pipelines.yml`, `vercel.json`, `netlify.toml`, `fly.toml`, `railway.json`

### 1.4 Check for existing `.claude/` configuration

Look for any existing Claude Code configuration that must be preserved:

- `.claude/` directory (commands, skills, agents, settings.json)
- `CLAUDE.md` at project root
- `.mcp.json`

Also check for other AI tool configs that may contain useful conventions:

- `.cursorrules` or `.cursor/rules/`
- `.github/copilot-instructions.md`

If existing `.claude/` config is found, note every file — these will be merged, never overwritten.

### 1.5 Read source files to extract conventions

Read 3–5 representative source files from the main source directory. In monorepos, pick files from the most active package. Pick files that are typical of the project — not config files, not generated code, not test files.

Look for:

- Naming conventions (camelCase, snake_case, PascalCase for types, etc.)
- Import organization patterns (grouped, sorted, aliased)
- Error handling patterns (try/catch, Result types, error wrapping with %w, etc.)
- Common abstractions or patterns (repository pattern, service pattern, etc.)
- File organization within directories
- How technologies interact (e.g., where do ORM queries live relative to API handlers?)

### 1.6 Read git history and branch info

First check if this is a git repo: `git rev-parse --is-inside-work-tree`. If not, skip this step entirely and note "no git repo" in your summary.

If it is a git repo, run:

- `git log --oneline -20` — recent commit messages (check for conventional commits, lowercase preference, commit style). If the project has no commits yet, note this and skip git conventions.
- `git branch -r` — remote branches (check for branch naming conventions like `feature/`, `fix/`, `main` vs `master`)

### 1.7 Read the detection guide

Read `PLUGIN_DIR/references/detection-guide.md` for the complete detection checklist. Use it to verify your findings and catch anything the steps above may have missed.

---

After completing all scan steps, summarize your findings before proceeding to Phase 2:

- **Language(s)** and version(s)
- **Framework(s)** (frontend, backend, styling, ORM, API)
- **Package manager**
- **Build tool**
- **Project pattern** (monorepo, standard app, library, Go standard layout, etc.)
- **Test framework(s)** (unit, E2E)
- **Linter(s) and formatter(s)**
- **CI/CD platform**
- **Database(s)**
- **Existing `.claude/` config** (if any)
- **Git conventions** (commit format, branch naming)
- **Available scripts/tasks**

---

## Phase 2: Generate Configuration

Using your scan findings from Phase 1, generate a tailored `.claude/` configuration for this project.

### 2.1 Read the generation guide

Read `PLUGIN_DIR/references/generation-guide.md` for guidelines on what good outputs look like. It contains principles, quality criteria, and examples from different stacks — use these as reference for quality, not as templates to fill.

### 2.2 Reason about what to generate

Based on your Phase 1 findings, reason about what commands, skills, and agents would genuinely help a developer working on THIS project. Consider the unique intersection of technologies — a Next.js + Prisma project needs different agents than a Next.js + Mongoose project.

Use the Output Reasoning Guide (section 9.7) as a starting point, not a checklist:

| Layer | Rule |
|-------|------|
| `CLAUDE.md` | **Always generate** using the template in section 9.1. Under 200 lines. Every line must be project-specific. |
| Commands | **Always generate** commit, implement, fix, review. **Consider** additional commands (optimize-db, security-audit) based on detections. Compose each using your scan results — see section 9.2 for guidelines and examples. |
| Skills | **Always generate** implement-feature, fix-bug, improve-architecture. **Consider** additional skills based on detections. Compose each with project-specific methodology — see section 9.3 for guidelines. |
| Agents | **Reason about** which agents would embed useful stack-specific knowledge. Always generate `architect`. Consider others based on detections. Each agent must contain knowledge specific to THIS project's stack intersection — see section 9.4 for guidelines and examples. |
| Hooks | Generate **only** when ALL 3 conditions are true: (1) tool binary confirmed installed via `command -v`, (2) command runs in under 30 seconds, (3) hook includes a disable comment. Use the exact format in section 9.5. |
| `.mcp.json` | Generate only when frameworks detected benefit from MCP servers. Use the exact format in section 9.6. |

**Quality bar:** Prefer fewer, higher-quality outputs over many generic ones. For each file you generate, ask: "What does this contain that is specific to THIS project?" If the answer is nothing beyond the project name, either add project-specific knowledge or skip it.

### 2.3 Handle existing configuration

If the project already has `.claude/` config, follow these conflict resolution rules:

- **`CLAUDE.md` exists** → merge sections: keep all existing content, add only missing sections
- **`.claude/commands/` has files** → skip existing commands, only generate new ones
- **`.claude/skills/` has directories** → skip existing skills, only generate new ones
- **`.claude/agents/` has files** → skip existing agents
- **`.claude/settings.json` exists** → merge hooks into existing settings (don't overwrite other settings)
- **`.mcp.json` exists** → merge servers (don't duplicate existing entries)

**Never overwrite existing configuration.**

### 2.4 Compose and write files

For each item you decided to generate, follow the Composition Process (section 9.8 of the generation guide):

1. **Gather context** — collect relevant Phase 1 findings for this output
2. **Identify stack intersections** — what does the developer need to know about how detected technologies interact?
3. **Compose from scratch** — use the guidelines and examples as quality reference, not templates to copy
4. **Validate before writing** — run the per-file checks from section 9.10

Structural outputs use exact formats: section 9.1 template for `CLAUDE.md`, section 9.5/9.6 for hooks/MCP.

For edge cases (no tests, no linter, monorepo, new project), follow the fallback strategies in section 9.9.

### 2.5 Quality validation

After writing all files, run the Quality Validation Checklist (section 9.10). Fix any issues before presenting to the user.

### 2.6 Generate INSTRUCTION.md

After validation passes, generate an `INSTRUCTION.md` in the project root using the template from section 9.11 of the generation guide.

- Include only sections for layers that were actually generated (commands, skills, agents, hooks, MCP)
- Fill in all project-specific values — stack names, framework versions, real command names
- Add 3–5 tips specific to the developer's detected stack
- Keep it under 150 lines
- Use a friendly, conversational tone

This file is a quick-start onboarding guide, not documentation. If the project already has an `INSTRUCTION.md`, skip this step.

---

## Phase 3: Present and Explain

After generating all files, present a clear summary to the user.

### 3.1 List every generated file grouped by layer

Organize the output as follows:

1. **CLAUDE.md** — show the file path
2. **Commands** — list each as `/command-name` with its one-line description
3. **Skills** — list each skill name with its description
4. **Agents** — list each with its isolation mode (worktree, separate context)
5. **Hooks** — list each with its lifecycle event (pre-commit, etc.)
6. **MCP servers** — list each server added to `.mcp.json`
7. **INSTRUCTION.md** — if generated, mention where to find it; if already present, mention it was preserved

### 3.2 Explain why each was generated

For every generated item, state which detection from Phase 1 triggered it. Example:

- `/component` command → "React detected in package.json dependencies"
- `design-system` skill → "Tailwind CSS detected in devDependencies"

### 3.3 Flag hooks with warnings

For each generated hook:

- Display a warning that it will run automatically
- Explain exactly how to disable it (which line to remove from `.claude/settings.json`)
- Remind the user they can review and remove any hook at any time

### 3.4 Offer validation

Offer build or test commands the user can run manually to validate the setup. Do not execute them from this command.

---

## Phase 4: Iterate

Ask the user these questions to refine the generated configuration:

1. "Are there workflows I missed that you do frequently?"
2. "Any conventions I got wrong?"
3. "Want to move anything between command ↔ skill?"
4. "Should I add or remove any agents or hooks?"

Update the generated files based on feedback. Repeat until the user is satisfied.

---

## Key Principles

Keep these in mind throughout all phases:

- **Detect, don't assume** — every generated line traces to a detected file
- **Specificity over generality** — no lines that could apply to any project
- **Composability** — deleting any generated file breaks nothing else
- **Safety first for hooks** — when in doubt, don't generate the hook
- **Less is more** — five excellent customizations > twenty generic ones
