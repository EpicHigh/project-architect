---
description: Create and run a database migration
allowed-tools: Bash, Read, Write, Glob
---

# Database Migration

## Arguments

- **name** (required): Migration name (e.g., `add_users_table`, `add_email_to_posts`)

## Steps

1. Modify the Ent schema in the appropriate schema file.
2. Run `go generate ./ent` to generate the migration.
3. Review the generated migration file.
4. Run the migration against the dev database.
5. Run tests to verify nothing broke.
