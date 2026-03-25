# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2026-03-25

### Changed

- **Skill generation aligned with Anthropic best practices** — Skills now follow [Anthropic's official skill-creator methodology](https://github.com/anthropics/skills/tree/main/skills/skill-creator): ~100 word "pushy" descriptions for better triggering, WHY-based instructions (theory of mind), concrete Input/Output examples, and lean content under 500 lines.

### Added

- **Evals for every skill** — Each generated skill now includes `evals/evals.json` with 2-3 realistic test prompts and objectively verifiable assertions, following Anthropic's eval framework.
- **Skill quality checks** — Per-file and cross-layer validation now includes description quality, eval existence, and size checks.

## [1.4.0] - 2026-03-25

### Fixed

- **WebFetch returns AI-processed summaries, not raw content** — WebFetch processes fetched content through a small AI model and returns a summary instead of the raw markdown file. This caused Claude to never see the original 200-400 line agents, falling back to writing 60-120 line agents from scratch every time. Replaced WebFetch with `curl -s` via Bash, which returns the exact raw content.

### Added

- **agency-agents repository structure catalog** — Complete catalog of all available agents with descriptions embedded in section 9.4 of the generation guide. Claude can now look up correct `{category}/{filename}` paths for `curl` without browsing the repo.

## [1.3.0] - 2026-03-25

### Fixed

- **Fetched agents discarded and rewritten from scratch** — Claude fetched 200-400 line agents then wrote 60-line versions from memory. Step 3 now explicitly says: "Write the fetched content directly to the file as-is, then revise in-place with targeted edits." No more rewriting from scratch after fetching.

### Changed

- Layer 4 Step 3 renamed from "Tailor" to "Write the fetched content as-is, then revise"
- Explicit 3-step process: (1) Write fetched content to file, (2) Revise with targeted edits, (3) Preserve original depth — do NOT summarize or condense

## [1.2.0] - 2026-03-25

### Fixed

- **Agents not fetched from agency-agents** — Claude skipped WebFetch and used fallback (compose from scratch) because fallback was too easy. Now: "You MUST use WebFetch for each agent. Do NOT skip the fetch step."
- **Agents too shallow** — 50-69 lines vs agency-agents originals at 200-400 lines. Added minimum 80 lines per agent requirement.

### Added

- Agent depth validation: at least 80 lines, all 7 sections, Stack Expertise must be the longest section
- Agent source validation: agents must be fetched from agency-agents via WebFetch
- Explicit "Do NOT use fallback to save tokens" instruction
- "Fetch each agent one by one" instruction to prevent batching/skipping

## [1.1.0] - 2026-03-25

### Fixed

- **Generation quality regression** — v1.0.0 produced minimal output (1 agent, 0 skills, no CLAUDE.md) because guidance was too permissive
- Changed "Consider generating" → "Generate When Detected (mandatory)" in section 9.7
- Changed "Reason about" → "Always generate + Generate when detected" for agents in Phase 2.2
- Added 3 universal agents (architect, product-manager, code-reviewer) to "Always Generate"
- Quality validation now has hard completeness checks: every detection-triggered output must exist
- Self-review now says "refine until specific" instead of "skip if generic" — outputs are refined, never deleted
- Layer 4 Step 1 now enforces mandatory agent selection from section 9.7

### Changed

- Section 9.7 renamed from "Output Reasoning Guide" to "Output Requirements"
- Philosophy shifted from "it's okay to skip" to "enforce minimum, reason beyond"

## [1.0.0] - 2026-03-25

### Added

- **Fetch & Tailor agent generation** — agents are now sourced from [agency-agents](https://github.com/msitarzewski/agency-agents) (144+ production agents) and tailored to each project's specific stack
- Layer 4 now uses WebFetch to retrieve agent definitions, then adapts them with project-specific knowledge from Phase 1
- Detection → agent mapping table covering 16+ agent types across engineering, testing, product, and design
- Required 7-section agent structure: Persona, Philosophy, Stack Expertise, Process, Success Metrics, Deliverables, Communication Style
- Expanded agent roster: product-manager, security-engineer, devops-automator, db-optimizer, api-tester, performance-benchmarker, ui-designer, accessibility-auditor, ai-engineer, mobile-app-builder, sre, technical-writer
- Fallback: compose from scratch if WebFetch unavailable

### Changed

- Section 9.4 completely rewritten from "compose agents from guidelines" to "fetch from agency-agents repo and tailor"
- Output Reasoning Guide (9.7) expanded with all new agent types

## [0.9.0] - 2026-03-25

### Added

- Workflow Connections section (9.8) — teaches Claude how layers connect as a pipeline: command → agent → skill → hook
- Connection checks in per-layer self-review (commands reference agents, skills reference agents, agents reference skills + commands)
- Cross-layer connection validation in final validation step
- Agent examples now show workflow connections ("Follows implement-feature skill methodology", "Complements /implement command")

### Changed

- Section numbering updated: 9.8 Workflow Connections, 9.9 Composition, 9.10 Edge Cases, 9.11 Quality Validation, 9.12 Self-Review, 9.13 INSTRUCTION.md

## [0.8.0] - 2026-03-24

### Changed

- Generation now uses per-layer self-review loops instead of batch review at the end
- Each layer (CLAUDE.md → Commands → Skills → Agents → Hooks → INSTRUCTION.md) is composed, self-reviewed, and refined to robust before moving to the next
- Cross-layer consistency checks after each layer ensure no contradictions
- Self-Review Criteria (section 9.11) updated with per-layer review focus table
- Composition Process (section 9.8) updated to reflect per-layer approach

## [0.7.0] - 2026-03-24

### Changed

- Command is now fully autonomous — runs to completion without asking questions
- Removed Phase 4 (Iterate) — the self-review loop in Phase 2 replaces manual user iteration
- Reduced from 4 phases to 3: Scan → Generate (with self-review) → Present
- Phase 3 now includes a self-review summary showing what was found and fixed
- Added "Autonomous completion" to Key Principles
- Updated all docs (README, ARCHITECTURE, CONTRIBUTING, SKILL.md) to reflect 3-phase flow

### Removed

- Phase 4 "Ask the user these questions" — autoresearch principle means generate → validate → refine → until robust, without mid-process questions

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
