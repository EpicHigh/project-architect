# Detection Guide

Reference for Phase 1 scanning. Use these tables to identify the project's tech stack, tools, and conventions.

---

## 8.1 Language Detection

| Language | Indicator Files | Version Source |
|----------|----------------|----------------|
| TypeScript | `tsconfig.json` | `package.json` → `devDependencies.typescript` |
| JavaScript | `package.json`, `.js` files | `package.json` → `engines.node` |
| Go | `go.mod` | `go.mod` → first line `go X.Y` |
| Rust | `Cargo.toml`, `rust-toolchain.toml` | `Cargo.toml` → `[package].rust-version`; `rust-toolchain.toml` → toolchain channel/version |
| Python | `pyproject.toml`, `setup.py`, `requirements.txt` | `pyproject.toml` → `[project].requires-python`; `.python-version` |
| Ruby | `Gemfile`, `*.gemspec` | `Gemfile` → `ruby "X.Y.Z"`; `.ruby-version` |
| Java | `pom.xml`, `build.gradle` | `pom.xml` → `<maven.compiler.source>`; `build.gradle` → `sourceCompatibility` |
| Kotlin | `build.gradle.kts`, `*.kt` files | `build.gradle.kts` → `kotlin("jvm")` plugin version |
| C# | `*.csproj`, `*.sln` | `*.csproj` → `<TargetFramework>` |
| Dart | `pubspec.yaml` | `pubspec.yaml` → `environment.sdk` |
| Swift | `Package.swift`, `*.xcodeproj` | `Package.swift` → `swift-tools-version:X.Y` |
| PHP | `composer.json` | `composer.json` → `require.php` |
| Elixir | `mix.exs` | `mix.exs` → `elixir: "~> X.Y"` |
| Zig | `build.zig`, `build.zig.zon` | `build.zig.zon` → `.minimum_zig_version` |
| Node.js | `package.json`, `.nvmrc`, `.node-version` | `.nvmrc`; `.node-version`; `package.json` → `engines.node` |
| Scala | `build.sbt` | `build.sbt` → `scalaVersion` |

---

## 8.2 Framework Detection

### Frontend Frameworks

| Framework | Check File | Look For |
|-----------|-----------|----------|
| React | `package.json` | `dependencies.react` or `devDependencies.react` |
| Vue | `package.json` | `dependencies.vue` |
| Angular | `package.json`, `angular.json` | `dependencies.@angular/core` |
| Svelte | `package.json` | `devDependencies.svelte` |
| Next.js | `package.json`, `next.config.*` | `dependencies.next` |
| Nuxt | `package.json`, `nuxt.config.*` | `dependencies.nuxt` |
| Remix | `package.json` | `dependencies.@remix-run/react` |
| Astro | `package.json`, `astro.config.*` | `dependencies.astro` |
| SolidJS | `package.json` | `dependencies.solid-js` |
| React Router | `package.json` | `dependencies.react-router` or `dependencies.react-router-dom` |
| SvelteKit | `package.json` | `devDependencies.@sveltejs/kit` |
| Gatsby | `package.json`, `gatsby-config.*` | `dependencies.gatsby` |
| Preact | `package.json` | `dependencies.preact` |
| Qwik | `package.json` | `dependencies.@builder.io/qwik` |
| Lit | `package.json` | `dependencies.lit` |
| Ember | `package.json` | `devDependencies.ember-cli` |

### Backend Frameworks

| Framework | Check File | Look For |
|-----------|-----------|----------|
| Express | `package.json` | `dependencies.express` |
| NestJS | `package.json`, `nest-cli.json` | `dependencies.@nestjs/core` |
| Fastify | `package.json` | `dependencies.fastify` |
| Hono | `package.json` | `dependencies.hono` |
| Koa | `package.json` | `dependencies.koa` |
| Gin | `go.mod` | `github.com/gin-gonic/gin` |
| Chi | `go.mod` | `github.com/go-chi/chi` (match prefix, ignore version suffix) |
| Echo | `go.mod` | `github.com/labstack/echo` (match prefix, ignore version suffix) |
| Fiber | `go.mod` | `github.com/gofiber/fiber` (match prefix, ignore version suffix) |
| ConnectRPC | `go.mod` or `package.json` | `connectrpc.com/connect` or `dependencies.@connectrpc/connect` |
| gRPC | `go.mod` or `package.json` | `google.golang.org/grpc` or `dependencies.@grpc/grpc-js` |
| FastAPI | `pyproject.toml`, `requirements.txt` | `fastapi` in dependencies |
| Django | `pyproject.toml`, `requirements.txt`, `manage.py` | `django` in dependencies |
| Flask | `pyproject.toml`, `requirements.txt` | `flask` in dependencies |
| Rails | `Gemfile` | `gem 'rails'` or `gem "rails"` |
| Spring Boot | `pom.xml`, `build.gradle` | `spring-boot-starter` |
| Phoenix | `mix.exs` | `{:phoenix,` in deps |
| Actix Web | `Cargo.toml` | `actix-web` in dependencies |

### Styling Frameworks

| Framework | Check File | Look For |
|-----------|-----------|----------|
| Tailwind CSS | `package.json`, `tailwind.config.*` | `devDependencies.tailwindcss` |
| Radix UI | `package.json` | `dependencies.@radix-ui/*` |
| shadcn/ui | `components.json` | `components.json` exists with `$schema` referencing shadcn |
| MUI | `package.json` | `dependencies.@mui/material` |
| Chakra UI | `package.json` | `dependencies.@chakra-ui/react` |
| Ant Design | `package.json` | `dependencies.antd` |
| Mantine | `package.json` | `dependencies.@mantine/core` |

### Data / ORM Frameworks

| Framework | Check File | Look For |
|-----------|-----------|----------|
| Prisma | `package.json`, `prisma/schema.prisma` | `devDependencies.prisma` or `dependencies.@prisma/client` |
| Drizzle | `package.json`, `drizzle.config.*` | `dependencies.drizzle-orm` |
| TypeORM | `package.json` | `dependencies.typeorm` |
| Sequelize | `package.json` | `dependencies.sequelize` |
| Mongoose | `package.json` | `dependencies.mongoose` |
| Ent ORM | `go.mod` | `entgo.io/ent` |
| GORM | `go.mod` | `gorm.io/gorm` |
| SQLAlchemy | `pyproject.toml`, `requirements.txt` | `sqlalchemy` in dependencies |
| Django ORM | `pyproject.toml`, `requirements.txt` | `django` in dependencies (built-in ORM) |
| ActiveRecord | `Gemfile` | `gem 'activerecord'` or `gem 'rails'` (Rails includes ActiveRecord) |

### API Frameworks

| Framework | Check File | Look For |
|-----------|-----------|----------|
| GraphQL | `package.json` | `dependencies.graphql` or `dependencies.@apollo/server` or `dependencies.graphql-yoga` |
| tRPC | `package.json` | `dependencies.@trpc/server` |
| ConnectRPC | `go.mod` or `package.json` | `connectrpc.com/connect` or `@connectrpc/connect` |
| gRPC | `go.mod` or `package.json` | `google.golang.org/grpc` or `@grpc/grpc-js` |
| REST + OpenAPI | `openapi.yaml`, `openapi.json`, `swagger.yaml`, `swagger.json` | File exists at project root or `docs/` directory |
| Swagger | `package.json` | `dependencies.@nestjs/swagger` or `dependencies.swagger-jsdoc` |

---

## 8.3 Package Manager Detection

| Lockfile | Package Manager |
|----------|----------------|
| `package-lock.json` | npm |
| `yarn.lock` | Yarn |
| `pnpm-lock.yaml` | pnpm |
| `bun.lockb` or `bun.lock` | Bun |
| `go.sum` | Go Modules |
| `Cargo.lock` | Cargo (Rust) |
| `poetry.lock` | Poetry (Python) |
| `uv.lock` | uv (Python) |
| `Pipfile.lock` | Pipenv |
| `Gemfile.lock` | Bundler (Ruby) |
| `composer.lock` | Composer (PHP) |
| `mix.lock` | Mix (Elixir) |
| `pubspec.lock` | Pub (Dart) |

**Note:** `requirements.txt` is a pip requirements file, not a lockfile. Its presence suggests pip usage but is not definitive — Poetry, uv, and pip-tools can all generate `requirements.txt`. Detect pip as the package manager only when no other Python lockfile (`poetry.lock`, `uv.lock`, `Pipfile.lock`) is present.

---

## 8.4 Build Tool Detection

### Config file detection

| Config File | Build Tool |
|-------------|-----------|
| `vite.config.*` | Vite |
| `webpack.config.*` | Webpack |
| `rollup.config.*` | Rollup |
| `.parcelrc` | Parcel |
| `.swcrc` or `swc.config.js` | SWC |
| `tsup.config.*` | tsup |
| `build.gradle` or `build.gradle.kts` | Gradle |
| `pom.xml` | Maven |
| `next.config.*` → `turbopack` key | Turbopack |

### package.json heuristic detection

These tools lack a standard config file. Detect via `package.json` scripts or devDependencies:

| Heuristic | Build Tool |
|-----------|-----------|
| `esbuild` in `package.json` scripts or `devDependencies` | esbuild |
| `parcel` in `package.json` scripts (when no `.parcelrc` exists) | Parcel |
| `@swc/core` in `devDependencies` (when no `.swcrc` exists) | SWC |

**Note:** Heuristic detection is weaker than config file detection. A tool in devDependencies may be an indirect dependency rather than the primary build tool. Prefer config file detection when available.

---

## 8.5 Project Pattern Detection

### Monorepo Indicators

These are **candidate signals**, not definitive proof. A repository is a monorepo only when **multiple distinct projects or packages** are actually present. Nx, Turborepo, Bazel, and Cargo workspaces can all be used in single-project repositories. After detecting a signal, verify by counting workspace members or distinct package manifests.

| Signal | File / Config |
|--------|--------------|
| pnpm workspaces | `pnpm-workspace.yaml` |
| npm/Yarn workspaces | `package.json` → `workspaces` field |
| Nx | `nx.json` |
| Lerna | `lerna.json` |
| Turborepo | `turbo.json` |
| Go workspaces | `go.work` |
| Cargo workspaces | `Cargo.toml` → `[workspace]` section |
| Bazel | `WORKSPACE` or `WORKSPACE.bazel` |

### Workspace Package Discovery

| Tool | How to find workspace packages |
|------|-------------------------------|
| pnpm | `pnpm-workspace.yaml` → `packages` array (glob patterns) |
| npm/Yarn | `package.json` → `workspaces` array (glob patterns) |
| Nx | `nx.json` → find `project.json` files in any directory, or detect workspace packages via `package.json` workspaces |
| Go | `go.work` → `use` directives |

### Project Layout Patterns

| Pattern | Detection Rule |
|---------|---------------|
| Go standard layout | `cmd/`, `internal/`, and optionally `pkg/` directories exist |
| Microservices | Multiple `Dockerfile` files or multiple service directories with independent configs |
| Standard app | Single `src/` or `app/` directory with one entry point |
| Library | `src/` + `index.*` or `lib/` as main export, no app entry point |

---

## 8.6 Testing Detection

### Unit / Integration Test Frameworks

| Framework | Config File | Detection |
|-----------|-----------|-----------|
| Jest | `jest.config.*`, `jest.config.ts`, `jest.config.js` | `devDependencies.jest` or `devDependencies.@jest/core` in `package.json` |
| Vitest | `vitest.config.*` | `devDependencies.vitest` in `package.json` |
| Mocha | `.mocharc.*`, `.mocharc.yml`, `.mocharc.json` | `devDependencies.mocha` in `package.json` |
| Jasmine | `jasmine.json`, `spec/support/jasmine.json` | `devDependencies.jasmine` in `package.json` |
| AVA | `ava.config.*`, `ava` field in `package.json` | `devDependencies.ava` in `package.json` |
| pytest | `pytest.ini`, `pyproject.toml` → `[tool.pytest]`, `setup.cfg` → `[tool:pytest]` | `pytest` in Python dependencies |
| unittest | No config file | `import unittest` in Python test files |
| Go testing | `*_test.go` files | Built-in — presence of `*_test.go` files |
| RSpec | `.rspec`, `spec/` directory | `gem 'rspec'` in `Gemfile` |
| Minitest | No config file | `gem 'minitest'` in `Gemfile` or `require 'minitest'` in test files |
| JUnit | `src/test/` directory | JUnit dependency in `pom.xml` or `build.gradle` |
| PHPUnit | `phpunit.xml`, `phpunit.xml.dist` | `require-dev.phpunit/phpunit` in `composer.json` |
| ExUnit | `test/` directory with `*_test.exs` files | Built-in with Elixir/Mix |

### E2E Test Frameworks

| Framework | Config File | Detection |
|-----------|-----------|-----------|
| Playwright | `playwright.config.*` | `devDependencies.@playwright/test` in `package.json` |
| Cypress | `cypress.config.*`, `cypress/` directory | `devDependencies.cypress` in `package.json` |
| Puppeteer | No standard config | `devDependencies.puppeteer` in `package.json` |
| Selenium | No standard config | `selenium` in dependencies (varies by language) |

### Test Command Extraction

To find how the project runs tests, check in order:

1. `package.json` → `scripts.test`, `scripts.test:unit`, `scripts.test:e2e`, `scripts.test:integration`
2. `Makefile` → targets named `test`, `test-unit`, `test-integration`, `test-e2e`
3. `justfile` → recipes named `test`
4. `Taskfile.yml` → tasks named `test`
5. Go projects → `go test ./...` (convention)
6. Python projects → `pytest` or `python -m pytest` (convention)
7. Ruby projects → `bundle exec rspec` or `rake test` (convention)

---

## 8.7 Linting & Formatting Detection

### Linters

| Linter | Config File |
|--------|-----------|
| ESLint | `.eslintrc.*`, `eslint.config.*` (flat config), `.eslintrc.json`, `.eslintrc.js`, `.eslintrc.yml` |
| Biome | `biome.json`, `biome.jsonc` |
| golangci-lint | `.golangci.yml`, `.golangci.yaml`, `.golangci.toml`, `.golangci.json` |
| Ruff | `ruff.toml`, `pyproject.toml` → `[tool.ruff]` |
| Pylint | `.pylintrc`, `pyproject.toml` → `[tool.pylint]` |
| Flake8 | `.flake8`, `setup.cfg` → `[flake8]` |
| RuboCop | `.rubocop.yml` |
| Stylelint | `.stylelintrc.*`, `stylelint.config.*` |
| Clippy | Built-in with Rust — check for `clippy` in CI or `Makefile` targets |

### Formatters

| Formatter | Config File |
|-----------|-----------|
| Prettier | `.prettierrc.*`, `prettier.config.*`, `.prettierrc.json`, `.prettierrc.js` |
| gofmt / goimports | Built-in with Go — no config file needed |
| Black | `pyproject.toml` → `[tool.black]` |
| Ruff (formatter) | `pyproject.toml` → `[tool.ruff.format]` |
| rustfmt | `rustfmt.toml`, `.rustfmt.toml` |
| EditorConfig | `.editorconfig` (cross-language formatting baseline) |

---

## 8.8 CI/CD Detection

| Path | Platform |
|------|----------|
| `.github/workflows/*.yml` or `.github/workflows/*.yaml` | GitHub Actions |
| `.gitlab-ci.yml` | GitLab CI |
| `.circleci/config.yml` | CircleCI |
| `Jenkinsfile` | Jenkins |
| `.travis.yml` | Travis CI |
| `bitbucket-pipelines.yml` | Bitbucket Pipelines |
| `vercel.json` or `.vercel/` | Vercel |
| `netlify.toml` | Netlify |
| `fly.toml` | Fly.io |
| `railway.json` or `railway.toml` | Railway |
| `render.yaml` | Render |
| `appveyor.yml` | AppVeyor |

---

## 8.9 Database Detection

### Via docker-compose services

Check `docker-compose.yml`, `docker-compose.yaml`, or `compose.yml` for service images:

| Image Pattern | Database |
|---------------|----------|
| `postgres`, `postgis` | PostgreSQL |
| `mysql`, `mariadb` | MySQL / MariaDB |
| `mongo` | MongoDB |
| `redis` | Redis |
| `memcached` | Memcached |
| `elasticsearch`, `opensearch` | Elasticsearch / OpenSearch |
| `mssql`, `mcr.microsoft.com/mssql` | SQL Server |
| `cassandra` | Cassandra |
| `dynamodb-local` | DynamoDB (local) |
| `cockroachdb/cockroach` | CockroachDB |

### Via dependencies

| Dependency | Database |
|-----------|----------|
| `pg` (npm), `psycopg2` (Python), `github.com/lib/pq` (Go) | PostgreSQL |
| `mysql2` (npm), `mysqlclient` (Python) | MySQL |
| `mongodb` (npm), `pymongo` (Python) | MongoDB |
| `redis` (npm), `redis-py` (Python), `github.com/redis/go-redis` (Go) | Redis |
| `sqlite3` (npm), `better-sqlite3` (npm) | SQLite |

---

## 8.10 Cloud & IaC Detection

### Cloud Providers

| Indicator | Provider |
|-----------|----------|
| `aws-sdk` or `@aws-sdk/*` in dependencies, `.aws/` directory | AWS |
| `@google-cloud/*` in dependencies, `gcloud` in CI | Google Cloud (GCP) |
| `@azure/*` in dependencies, `.azure/` directory | Azure |
| `doctl` in CI, `digitalocean` in configs | DigitalOcean |
| `fly.toml` | Fly.io |
| `railway.json` or `railway.toml` | Railway |
| `supabase/` directory, `supabase` in dependencies | Supabase |

### Infrastructure as Code (IaC)

| Config File | Tool |
|-------------|------|
| `*.tf`, `terraform/` directory | Terraform |
| `Pulumi.yaml`, `Pulumi.*.yaml` | Pulumi |
| `cdk.json`, `lib/*.ts` with CDK imports | AWS CDK |
| `template.yaml` or `template.json` (SAM/CloudFormation) | CloudFormation / SAM |
| `ansible/`, `playbook.yml`, `*.ansible.yml` | Ansible |
| `Chart.yaml`, `charts/` directory | Helm |
| `serverless.yml` | Serverless Framework |

---

## 8.11 Container Detection

| Indicator | Technology |
|-----------|-----------|
| `Dockerfile` | Docker |
| `docker-compose.yml`, `docker-compose.yaml`, or `compose.yml` | Docker Compose |
| `.dockerignore` | Docker (supporting file) |
| `k8s/`, `kubernetes/`, `deploy/*.yaml` with `kind:` fields | Kubernetes |
| `Chart.yaml`, `templates/` with K8s manifests | Helm |
| `skaffold.yaml` | Skaffold |
| `kustomization.yaml`, `kustomize/` | Kustomize |
| `Tiltfile` | Tilt |

---

## 8.12 Git Convention Detection

Extract conventions from git history. Run these commands and analyze the output:

### Commit format

Run `git log --oneline -20` and check:

| Pattern | Convention |
|---------|-----------|
| Commits start with `feat:`, `fix:`, `chore:`, `docs:`, etc. | Conventional Commits |
| Commits start with uppercase | Capitalized subjects |
| Commits start with lowercase | Lowercase subjects |
| Commits reference ticket numbers (e.g., `PROJ-123`) | Ticket-prefixed commits |

### Branch naming

Run `git branch -r` and check:

| Pattern | Convention |
|---------|-----------|
| `feature/*`, `fix/*`, `hotfix/*` | GitFlow-style branches |
| `feat/*`, `fix/*`, `chore/*` | Conventional branch prefixes |
| `main` | Main branch (modern default) |
| `master` | Master branch (legacy default) |
| `develop` or `dev` | Development branch |

---

## 8.13 Existing Config Detection

Check for existing AI tool configurations that must be preserved or referenced:

| File / Directory | Tool |
|-----------------|------|
| `.claude/` directory | Claude Code (commands, skills, agents, settings) |
| `CLAUDE.md` | Claude Code project config |
| `.mcp.json` | MCP server configuration |
| `.cursorrules` | Cursor AI rules |
| `.cursor/rules/` | Cursor AI rules (directory format) |
| `.github/copilot-instructions.md` | GitHub Copilot instructions |
| `.aider*` | Aider configuration |
| `.continue/` | Continue.dev configuration |

If any Claude Code config exists, note all files — these will be **merged, never overwritten** during generation.

If non-Claude AI configs exist (`.cursorrules`, copilot instructions), extract useful conventions from them to incorporate into the generated `.claude/` config.

---

## 8.14 Script Detection

### package.json scripts

Read `package.json` → `scripts` object. Common keys to look for:

`dev`, `start`, `build`, `test`, `test:unit`, `test:e2e`, `lint`, `lint:fix`, `format`, `typecheck`, `clean`, `preview`, `deploy`, `db:migrate`, `db:seed`, `db:push`, `generate`, `codegen`

### Makefile targets

Read `Makefile` and extract target names (lines matching `^target-name:`). Common targets:

`build`, `test`, `lint`, `run`, `dev`, `clean`, `install`, `deploy`, `docker-build`, `docker-run`, `migrate`, `generate`, `proto`

### justfile recipes

Read `justfile` and extract recipe names (lines matching `^recipe-name:`). Same common names as Makefile.

### Taskfile tasks

Read `Taskfile.yml` → `tasks` keys. Same common names as Makefile.
