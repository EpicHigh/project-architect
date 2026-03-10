---
name: schema-patterns
description: >
  react-next-app database schema and data access patterns.
  Activates when: creating models, writing migrations, querying data,
  designing relationships, optimizing queries, managing database schema.
---

# Schema Patterns — react-next-app

## Stack

- **Database:** PostgreSQL
- **ORM:** Prisma
- **Schema location:** `prisma/`

## Conventions

- Find existing models in `prisma/schema.prisma` and follow the same patterns.
- Check for naming conventions, relationship patterns, and timestamp columns.

## Migrations

```sh
npx prisma migrate dev
```
