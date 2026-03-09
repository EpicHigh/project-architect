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
| Chi | `go.mod` | `github.com/go-chi/chi/v5` |
| Echo | `go.mod` | `github.com/labstack/echo/v5` |
| Fiber | `go.mod` | `github.com/gofiber/fiber/v3` |
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

<!-- Sections 8.3–8.14 will be added in Stories 7, 8, 9 -->
