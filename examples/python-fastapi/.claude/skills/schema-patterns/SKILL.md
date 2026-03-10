---
name: schema-patterns
description: >
  python-fastapi database schema and data access patterns.
  Activates when: creating models, writing migrations, querying data,
  designing relationships, optimizing queries, managing database schema.
---

# Schema Patterns — python-fastapi

## Stack

- **Database:** PostgreSQL
- **ORM:** SQLAlchemy

## Conventions

- Find existing models in `app/models/` and follow the same patterns.
- Check for naming conventions, relationship patterns, and column types.

## Migrations

```sh
alembic revision --autogenerate -m "add_users_table"
alembic upgrade head
```
