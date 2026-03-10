---
name: design-system
description: >
  react-next-app design system and styling patterns.
  Activates when: styling components, choosing colors or spacing, applying theme tokens,
  creating layouts, using Tailwind CSS utilities, maintaining visual consistency.
---

# Design System — react-next-app

## Styling Approach

- **Framework:** Tailwind CSS
- **Config:** `tailwind.config.ts`

## Tailwind Conventions

- Reference `tailwind.config.ts` for custom theme values (colors, spacing, breakpoints).
- Use utility classes directly; avoid `@apply` unless creating reusable component styles.
- Follow the project's existing class ordering pattern.
