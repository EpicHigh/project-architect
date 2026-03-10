---
description: Create and run a database migration
allowed-tools: Bash, Read, Write, Glob
---

# Database Migration

## Arguments

- **name** (required): Migration name (e.g., `add_users_table`, `add_email_to_posts`)

## Steps

1. Update the SQLAlchemy model in `app/models/`.
2. Run `alembic revision --autogenerate -m "add_users_table"`.
3. Review the generated migration file.
4. Run the migration: `alembic upgrade head`.
5. Run tests to verify nothing broke.
