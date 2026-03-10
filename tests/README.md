# Test Fixtures

Minimal config-only project stubs for testing `project-architect` detection and generation.

## Fixtures

| Fixture | Stack | Key Detections | Expected Commands |
|---------|-------|----------------|-------------------|
| `react-next-app` | TypeScript, React, Next.js, Tailwind, Prisma, Jest, ESLint | Frontend, database, test framework, linter | commit, review, explain, component, page, migrate, test |
| `go-api-server` | Go, Gin, Ent ORM, ConnectRPC, golangci-lint | Backend, database, linter, Go standard layout | commit, review, explain, endpoint, migrate |
| `python-fastapi` | Python, FastAPI, SQLAlchemy, pytest, Ruff | Backend, database, test framework, linter | commit, review, explain, endpoint, migrate, test |
| `nx-monorepo` | TypeScript, Nx, pnpm workspaces | Monorepo, package manager | commit, review, explain, new-package |
| `empty-project` | None | No frameworks or tools | commit, review, explain |

## Usage

Run `/project-architect` against a fixture directory to verify detection and generation:

```sh
cd tests/fixtures/react-next-app
claude /project-architect
```

## Design Rules

- **Config only** — no application code, just config files and directory stubs
- **Valid files** — all JSON, YAML, TOML, and config files must be parseable
- **Minimal** — include only what's needed to trigger the target detections
- **Directory stubs** — use `.gitkeep` files to preserve empty directories
