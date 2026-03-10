---
description: Create a new Gin API endpoint
allowed-tools: Read, Write, Glob, Grep
---

# New Endpoint

## Arguments

- **method** (required): HTTP method (GET, POST, PUT, DELETE, PATCH)
- **path** (required): URL path (e.g., `/api/users/:id`)

## Steps

1. Determine the appropriate file:
   - Look in `internal/handler/` for existing routes.
2. Create the endpoint following Gin conventions:
   - Find an existing endpoint in the codebase and use it as a reference.
   - Add handler function and register route.
3. Include:
   - Input validation
   - Error handling following project patterns
   - Ent query for data access
4. Create a test for the endpoint.
