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
✓ CLAUDE.md — project overview, build/test/lint commands
✓ 7 commands — commit, review, explain, component, page, migrate, test
✓ 5 skills — code-conventions, project-context, design-system, schema-patterns, test-patterns
✓ 1 agent — test-writer
✓ 1 hook — lint + test pre-commit
✓ 1 MCP server — Context7 for Next.js docs
```

## Install

```sh
# Clone and install locally
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
2. **Generate** — produces configuration from templates matched to your detections
3. **Present** — shows what was generated and why
4. **Iterate** — refine based on your feedback

## What Gets Generated

| Layer | Output | When |
| --- | --- | --- |
| CLAUDE.md | Project overview, build/test/lint commands, conventions | Always |
| Commands | `commit`, `review`, `explain` | Always |
| Commands | `component`, `page` | Frontend framework detected |
| Commands | `endpoint` | Backend framework detected |
| Commands | `migrate` | Database/ORM detected |
| Commands | `test` | Test framework detected |
| Commands | `e2e` | E2E framework detected |
| Commands | `docker` | Docker detected |
| Commands | `deploy` | CI/CD detected |
| Commands | `new-package` | Monorepo detected |
| Skills | `code-conventions`, `project-context` | Always |
| Skills | `design-system` | Frontend framework detected |
| Skills | `api-patterns` | Backend framework detected |
| Skills | `schema-patterns` | Database/ORM detected |
| Skills | `test-patterns` | Test framework detected |
| Agents | `test-writer` | Test framework detected |
| Agents | `reviewer` | CI/CD detected |
| Agents | `refactor-agent` | Tests + linter + coverage detected |
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
references/generation-guide.md     → Templates for generated output
```

## Examples

See complete generated output for different stacks:

- **[React + Next.js](examples/react-nextjs/)** — 7 commands, 5 skills, 1 agent, hooks, MCP
- **[Go API Server](examples/go-api/)** — 5 commands, 4 skills, hooks
- **[Python + FastAPI](examples/python-fastapi/)** — 6 commands, 5 skills, 1 agent, hooks, MCP

## Customization

After generation, everything is yours to edit:

- **Add commands** — create `.md` files in `.claude/commands/`
- **Add skills** — create `SKILL.md` in `.claude/skills/<name>/`
- **Tune hooks** — edit `.claude/settings.json`
- **Re-run** — run `/project-architect` again to regenerate (it merges with existing config, never overwrites)

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

The short version: it's all markdown. Adding support for a new stack is a 5-step process — add detection entries, add generation templates, add a test fixture, generate an example, and update this README.

## License

[MIT](LICENSE)
