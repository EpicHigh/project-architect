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

Read 3–5 representative source files from the main source directory. Look for:

- Naming conventions (camelCase, snake_case, PascalCase for types, etc.)
- Import organization patterns (grouped, sorted, aliased)
- Error handling patterns
- Common abstractions or patterns (repository pattern, service pattern, etc.)
- File organization within directories

Pick files that are typical of the project — not config files, not generated code.

### 1.6 Read git history and branch info

Run:
- `git log --oneline -20` — recent commit messages (check for conventional commits, lowercase preference, commit style)
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

<!-- Phase 2: Generate Configuration — Story 3 -->
<!-- Phase 3: Present and Explain — Story 4 -->
<!-- Phase 4: Iterate — Story 4 -->
