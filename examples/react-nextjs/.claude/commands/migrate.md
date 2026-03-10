---
description: Create and run a database migration
allowed-tools: Bash, Read, Write, Glob
---

# Database Migration

## Arguments

- **name** (required): Migration name (e.g., `add_users_table`, `add_email_to_posts`)

## Steps

1. Edit `prisma/schema.prisma` with the schema change.
2. Run `npx prisma migrate dev --name add_users_table`.
3. Review the generated migration file.
4. Run the migration against the dev database.
5. Run tests to verify nothing broke.
