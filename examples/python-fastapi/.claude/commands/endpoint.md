---
description: Create a new FastAPI API endpoint
allowed-tools: Read, Write, Glob, Grep
---

# New Endpoint

## Arguments

- **method** (required): HTTP method (GET, POST, PUT, DELETE, PATCH)
- **path** (required): URL path (e.g., `/api/users/{user_id}`)

## Steps

1. Determine the appropriate file:
   - Look in `app/routers/` for existing routes.
2. Create the endpoint following FastAPI conventions:
   - Find an existing endpoint in the codebase and use it as a reference.
   - Add view/route function with appropriate decorator.
3. Include:
   - Input validation via Pydantic models
   - Error handling following project patterns
   - SQLAlchemy query for data access
4. Create a test for the endpoint.
