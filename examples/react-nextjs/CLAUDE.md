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

## Database

- **Engine:** PostgreSQL
- **ORM:** Prisma
- **Migrations:** `npx prisma migrate dev`
