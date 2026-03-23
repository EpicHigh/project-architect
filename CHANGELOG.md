# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.0] - 2026-03-23

### Added

- Self-Review & Refine Loop (Phase 2.5) — autoresearch-style iterative improvement built into the generation process. Claude generates → reviews its own output → identifies areas of improvement and gaps → refines → repeats until no issues remain.
- Self-Review Criteria (section 9.11) — structured checklist: stack intersection depth, command accuracy, specificity test, workflow gaps, agent blind spots, anti-patterns to eliminate.
- Stopping criteria for the review loop (stop when zero issues found, typically 1-3 passes).

### Changed

- Phase 2 now has 7 steps (was 6): added self-review loop between composition and quality validation
- Generation process is no longer "generate once and present" — it's "generate → validate → refine → until robust"

## [0.5.0] - 2026-03-23

### Added

- Composition Process (section 9.8) — structured methodology for composing outputs (gather context → identify stack intersections → compose → validate)
- Edge Cases and Fallbacks (section 9.9) — handling for no-tests, no-linter, new projects, monorepos, multiple databases, libraries
- Quality Validation Checklist (section 9.10) — per-file, cross-file, and completeness checks
- Phase 1: Dockerfile, docker-compose, deno.json, .env.example scanning
- Phase 1: edge case handling for new projects with no git history
- Phase 2: quality validation step before presenting to user

### Changed

- Updated CLAUDE.md, CONTRIBUTING.md, README.md to reflect guideline-driven approach

## [0.4.0] - 2026-03-23

### Changed

- Generation guide: replaced all `{{ if/else }}` template blocks with guidelines + quality criteria + examples
- Commands, skills, and agents are now composed from scratch using critical thinking about the project's stack intersection, not mechanical template-filling
- Phase 2 instructions: "select template, fill placeholders" → "read guidelines, reason about needs, compose from scratch"
- Generation guide reduced from ~1900 lines to ~830 lines
- Templates remain only for structural outputs (CLAUDE.md, hooks, MCP, INSTRUCTION.md)

## [0.3.0] - 2026-03-23

### Added

- Detection-driven agent templates with `{{ if }}` conditionals for framework-specific knowledge
- `developer` agent (replaces `implementer`) with React/Vue/Angular/Go/Python patterns
- `db-specialist` agent with ORM-specific expertise (Prisma, Drizzle, SQLAlchemy, Ent, GORM)
- `devops` agent with Docker + CI/CD platform expertise
- `optimize-db` and `security-audit` conditional commands

### Changed

- Agents now adapt to detected stack using conditionals (React project gets React-specific agent, Go project gets Go-specific agent)
- `reviewer` agent enhanced with stack-specific review checklists and OWASP security checklist
- `qa` agent enhanced with framework-specific test patterns (Jest, pytest, Go testing, Playwright, Cypress)
- Selection matrix updated with new agent/command mappings

### Removed

- Generic `implementer` agent (replaced by stack-aware `developer`)

## [0.2.0] - 2026-03-23

### Added

- Methodology-driven skills: `implement-feature`, `fix-bug`, `improve-architecture`
- `tdd` skill for test-driven development
- Practical workflow commands: `implement`, `fix`
- Agent team: `implementer`, `architect`, `reviewer`, `qa`, `fixer`
- Severity-tagged code review (blocker/suggestion/nit)

### Changed

- `review` command rewritten with structured severity tags and actionable fixes

### Removed

- Generic scaffold commands: `component`, `page`, `endpoint`, `explain`, `migrate`, `test`, `e2e`, `docker`, `deploy`, `new-package`
- Info-dump skills: `code-conventions`, `project-context`, `test-patterns`
- Thin wrapper agents: `test-writer`, `refactor-agent`

## [0.1.0] - 2026-03-11

### Added

- Plugin manifest (`.claude-plugin/plugin.json`) and marketplace config
- Main `/project-architect` command with 4-phase workflow (Scan, Generate, Present, Iterate)
- `project-scanner` bridging skill for auto-activation
- Detection guide covering 16 categories of technology detection
- Generation guide with templates for CLAUDE.md, commands, skills, agents, hooks, and MCP
- Selection matrix mapping detections to generated outputs
- Test fixtures for 5 stacks (react-next-app, go-api-server, python-fastapi, nx-monorepo, empty-project)
- Example outputs for 3 stacks (react-nextjs, go-api, python-fastapi)
- GitHub Actions CI workflow with markdown linting
- README, CONTRIBUTING, ARCHITECTURE documentation
- INSTRUCTION.md onboarding guide generation
