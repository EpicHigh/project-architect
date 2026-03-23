# project-architect

> Scan any codebase. Generate tailored Claude Code configuration — automatically.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## What is this?

**project-architect** is a [Claude Code](https://claude.ai/code) plugin that analyzes your project's tech stack and generates a complete `.claude/` configuration — CLAUDE.md, commands, skills, agents, hooks, and MCP servers — all tailored to how your project actually works. No manual setup, no guessing.

## Demo

```
> /project-architect

Scanning project...
✓ Detected: TypeScript, Next.js 14, Tailwind CSS, Prisma, Jest, ESLint
✓ Found: app router, PostgreSQL, GitHub Actions

Generating configuration...
✓ CLAUDE.md — project overview, build/test/lint commands, conventions
✓ Commands — commit, implement, fix, review + optimize-db (Prisma detected), security-audit (API detected)
✓ Skills — implement-feature, fix-bug, improve-architecture, tdd, design-system, schema-patterns
✓ Agents — architect, developer (Next.js+Prisma+Tailwind), reviewer (React+security), db-specialist (Prisma+PostgreSQL), devops (GitHub Actions), qa (Jest), fixer
✓ Hook — lint + test pre-commit (ESLint + Jest confirmed installed)
✓ MCP — Context7 for Next.js docs
```

## Install

```
# Add the marketplace and install
/plugin marketplace add EpicHigh/claude-project-architect
/plugin install project-architect@EpicHigh-claude-project-architect
```

Or install locally for development:

```sh
git clone https://github.com/EpicHigh/claude-project-architect.git
claude --plugin-dir ./claude-project-architect
```

## Usage

Open Claude Code in your project and run:

```
/project-architect
```

The plugin runs in 4 phases:

1. **Scan** — reads config files, directory structure, git history (read-only, never executes code)
2. **Generate** — composes configuration tailored to your project's specific stack intersection
3. **Present** — shows what was generated and why
4. **Iterate** — refine based on your feedback

## What Gets Generated

| Layer | Output | When |
| --- | --- | --- |
| CLAUDE.md | Project overview, build/test/lint commands, conventions | Always |
| Commands | `commit`, `implement`, `fix`, `review` | Always |
| Commands | `optimize-db` | Database/ORM detected |
| Commands | `security-audit` | Backend framework detected |
| Skills | `implement-feature`, `fix-bug`, `improve-architecture` | Always |
| Skills | `tdd` | Test framework detected |
| Skills | `design-system` | Styling framework detected |
| Skills | `api-patterns` | Backend framework detected |
| Skills | `schema-patterns` | Database/ORM detected |
| Agents | `architect` (stack-aware) | Always |
| Agents | `reviewer` (stack-specific checklists + security) | Linter or test framework detected |
| Agents | `developer` (framework-specific patterns) | Test framework + linter detected |
| Agents | `db-specialist` (ORM + engine expertise) | Database/ORM detected |
| Agents | `devops` (Docker + CI/CD optimization) | Docker or CI/CD detected |
| Agents | `qa` (test framework patterns) | Test framework detected |
| Agents | `fixer` (language-specific debugging) | Test framework detected |
| Hooks | lint pre-commit | Linter detected |
| Hooks | lint + test pre-commit | Linter + fast tests detected |
| MCP | Context7 docs server | Framework with docs detected |

## Supported Stacks

project-architect detects and generates configuration for a wide range of technologies.

### Languages

TypeScript, JavaScript, Python, Go, Rust, Ruby, Java, Kotlin, C#, Swift, Dart, PHP, Elixir, Scala, Zig

### Frontend Frameworks

React, Vue, Angular, Svelte, Next.js, Nuxt, Remix, Astro, SolidJS, SvelteKit, Gatsby, Preact, Qwik, Lit, Ember

### Backend Frameworks

Express, NestJS, Fastify, Hono, Koa, Gin, Chi, Echo, Fiber, ConnectRPC, gRPC, FastAPI, Django, Flask, Rails, Spring Boot, Phoenix, Actix Web

### Databases & ORMs

PostgreSQL, MySQL, MongoDB, Redis, SQLite, Elasticsearch, SQL Server, DynamoDB, CockroachDB
Prisma, Drizzle, TypeORM, Sequelize, Mongoose, Ent, GORM, SQLAlchemy, Django ORM, ActiveRecord

### Build Tools & Package Managers

Vite, Webpack, Rollup, Parcel, esbuild, SWC, tsup, Turbopack, Gradle, Maven
npm, Yarn, pnpm, Bun, Go Modules, Cargo, Poetry, uv, Bundler, Composer

### Testing

Jest, Vitest, Mocha, pytest, Go testing, RSpec, JUnit, Playwright, Cypress, Puppeteer

### Linters & Formatters

ESLint, Biome, Prettier, golangci-lint, Ruff, Black, RuboCop, Clippy, rustfmt

### CI/CD & Cloud

GitHub Actions, GitLab CI, CircleCI, Jenkins, Vercel, Netlify, Fly.io
AWS, GCP, Azure, Docker, Kubernetes, Terraform, Pulumi

### Monorepo Tools

pnpm workspaces, npm workspaces, Nx, Lerna, Turborepo, Go workspaces, Cargo workspaces, Bazel

## How It Works

project-architect is a Claude Code plugin — it's pure markdown and JSON, no executable code. The slash command tells Claude what to scan ([detection-guide.md](references/detection-guide.md)) and what to generate ([generation-guide.md](references/generation-guide.md)). Claude does the rest using its built-in tools (Read, Glob, Grep, Bash, Write).

**Architecture:**

```
.claude-plugin/plugin.json        → Plugin manifest
commands/project-architect.md      → Main command (4 phases)
references/detection-guide.md      → What to look for during scan
references/generation-guide.md     → Guidelines and examples for output composition
```

## Examples

See complete generated output for different stacks:

- **[React + Next.js](examples/react-nextjs/)** — commands, skills, agents tailored to Next.js + Prisma + Tailwind + Jest
- **[Go API Server](examples/go-api/)** — commands, skills, agents tailored to Go + Gin + Ent + golangci-lint
- **[Python + FastAPI](examples/python-fastapi/)** — commands, skills, agents tailored to FastAPI + SQLAlchemy + pytest + Ruff

## Customization

After generation, everything is yours to edit:

- **Add commands** — create `.md` files in `.claude/commands/`
- **Add skills** — create `SKILL.md` in `.claude/skills/<name>/`
- **Tune hooks** — edit `.claude/settings.json`
- **Re-run** — run `/project-architect` again to regenerate (it merges with existing config, never overwrites)

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

The short version: it's all markdown. Adding support for a new stack means adding detection entries to `detection-guide.md` and examples to `generation-guide.md`.

## License

[MIT](LICENSE)
