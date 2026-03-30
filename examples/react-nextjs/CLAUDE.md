# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

react-next-app is a TypeScript web application using Next.js 14.

## Build & Development

### Build

```sh
npm run build
```

### Development Server

```sh
npm run dev
```

## Testing

### Run All Tests

```sh
npm test
```

### Run a Single Test

```sh
npx jest path/to/test
```

### Coverage

```sh
npm run test:coverage
```

## Linting & Formatting

### Lint

```sh
npm run lint
```

## Working Style

Don't take shortcuts — read and explore before writing. Don't be lazy — produce thorough, complete output with proper error handling, validation, and tests. Don't hallucinate — only reference files, APIs, and imports that actually exist. Don't over-engineer — match the existing codebase's complexity level. Stay on scope — only change what was asked. Always verify — run lint and tests before declaring done.

- **Read component boundary before adding data access** — Prisma queries belong in Server Components or server actions (`app/` files without `'use client'`); the bundler fails because Prisma depends on Node.js APIs unavailable in the browser
- **Check `app/` route structure before creating files** — `page.tsx`, `layout.tsx`, `loading.tsx` have special meanings in App Router; misnamed files silently break routing
- **Run `npm test` before and after changes** — Jest tests use the project's custom config; you cannot distinguish pre-existing failures from regressions without a baseline
- **Read existing Prisma schema before adding models** — `prisma/schema.prisma` has established relation patterns; inconsistent relations cause migration failures
- **Check `components/ui/` before building custom UI** — This project uses shadcn/ui primitives; duplicating existing components creates visual inconsistency
- **Implement complete Server Actions with validation and error handling** — A Server Action without Zod validation or try/catch returns raw errors to the client; every action needs input validation and a user-facing error response
- **Write tests that verify rendered output, not just render-without-crash** — A test that only calls `render(<Component />)` without assertions catches nothing; assert on visible text, user interactions, and state changes
- **Only import modules that exist in this project** — Inventing an import like `from @/lib/auth` when `lib/auth.ts` doesn't exist causes build failures; use Glob to verify before importing
- **Match the existing component complexity — don't add unnecessary abstractions** — If existing pages fetch data directly in Server Components, don't introduce a custom data-fetching layer that nothing else uses
- **Only change what was asked — don't refactor adjacent components** — Being asked to "fix the form validation" doesn't authorize restructuring the entire form library; unrelated changes create unreviewed risk
- **Run `npm run lint` and `npm test` before declaring a task complete** — Saying "this should work" without running lint and tests leaves broken code for the user to debug

## Database

- **Engine:** PostgreSQL
- **ORM:** Prisma
- **Migrations:** `npx prisma migrate dev`
