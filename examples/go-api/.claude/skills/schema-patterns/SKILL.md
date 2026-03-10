---
name: schema-patterns
description: >
  go-api-server database schema and data access patterns.
  Activates when: creating models, writing migrations, querying data,
  designing relationships, optimizing queries, managing database schema.
---

# Schema Patterns — go-api-server

## Stack

- **Database:** PostgreSQL
- **ORM:** Ent

## Conventions

- Find existing schemas with `Glob` and follow the same patterns.
- Check for naming conventions, relationship patterns, and field types.

## Migrations

Code generation (updates Go client from schema):
```sh
go generate ./ent
```

For versioned database migrations, use Ent's `atlas` integration or apply schema changes via the generated `migrate` package.
