---
description: Analyze your codebase and generate Claude Code configuration (CLAUDE.md, skills, agents, hooks)
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# Project Architect

You are a project analysis assistant. Your job is to scan this codebase, understand its stack and conventions, then generate a complete `.claude/` configuration tailored to this project. Run autonomously through all 3 phases — Scan, Generate (with self-review), Present — without asking questions.

> **SAFETY: Do NOT execute project code, run builds, or install dependencies. Only read files and fetch agent definitions from agency-agents via `curl`.**

---

## Phase 1: Scan the Project

Gather project information using read-only tools. Work through each category below, recording what you find.

### 1.1 Read root config files (highest signal)

Check for and read these files at the project root. Extract the tech stack, dependencies, and versions:

- `package.json` — name, dependencies, devDependencies, scripts, workspaces
- `go.mod` — module path, Go version, dependencies
- `pyproject.toml` — project metadata, dependencies, build system
- `Cargo.toml` — package info, dependencies, workspace members
- `composer.json` — PHP dependencies, autoload config
- `Gemfile` — Ruby dependencies
- `build.gradle` / `build.gradle.kts` — Java/Kotlin dependencies, plugins
- `pom.xml` — Maven dependencies, plugins
- `pubspec.yaml` — Dart/Flutter dependencies
- `mix.exs` — Elixir dependencies
- `Makefile`, `justfile`, `Taskfile.yml` — available task runner targets
- `Dockerfile`, `docker-compose.yml` — containerization
- `deno.json` / `deno.jsonc` — Deno runtime
- `.env.example` — environment variable patterns (do NOT read `.env` — may contain secrets)

Read whichever files exist. Skip the rest silently.

### 1.2 List directory structure

Run: `find . -maxdepth 2 -type d -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/__pycache__/*' -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/.next/*' -not -path '*/target/*'`

Note the top-level directories and what they suggest about the project pattern (monorepo, Go standard layout, typical app structure, library, etc.).

### 1.3 Check for test, linter, and CI/CD configs

Scan for the presence of these files (do not read their full contents unless needed for detection):

**Testing:**
`jest.config.*`, `vitest.config.*`, `pytest.ini`, `pyproject.toml [tool.pytest]`, `.mocharc.*`, `cypress.config.*`, `playwright.config.*`, `phpunit.xml`, `.rspec`, `*_test.go`

**Linting & formatting:**
`.eslintrc*`, `eslint.config.*`, `biome.json`, `.prettierrc*`, `.golangci.yml`, `ruff.toml`, `.rubocop.yml`, `.stylelintrc*`, `.editorconfig`

**CI/CD:**
`.github/workflows/`, `.gitlab-ci.yml`, `.circleci/`, `Jenkinsfile`, `.travis.yml`, `bitbucket-pipelines.yml`, `vercel.json`, `netlify.toml`, `fly.toml`, `railway.json`

### 1.4 Check for existing `.claude/` configuration

Look for any existing Claude Code configuration that must be preserved:

- `.claude/` directory (skills, agents, settings.json)
- `CLAUDE.md` at project root
- `.mcp.json`

Also check for other AI tool configs that may contain useful conventions:

- `.cursorrules` or `.cursor/rules/`
- `.github/copilot-instructions.md`

If existing `.claude/` config is found, note every file — these will be merged, never overwritten.

### 1.5 Read source files to extract conventions

Read 3–5 representative source files from the main source directory. In monorepos, pick files from the most active package. Pick files that are typical of the project — not config files, not generated code, not test files.

Look for:

- Naming conventions (camelCase, snake_case, PascalCase for types, etc.)
- Import organization patterns (grouped, sorted, aliased)
- Error handling patterns (try/catch, Result types, error wrapping with %w, etc.)
- Common abstractions or patterns (repository pattern, service pattern, etc.)
- File organization within directories
- How technologies interact (e.g., where do ORM queries live relative to API handlers?)

### 1.6 Read git history and branch info

First check if this is a git repo: `git rev-parse --is-inside-work-tree`. If not, skip this step entirely and note "no git repo" in your summary.

If it is a git repo, run:

- `git log --oneline -20` — recent commit messages (check for conventional commits, lowercase preference, commit style). If the project has no commits yet, note this and skip git conventions.
- `git branch -r` — remote branches (check for branch naming conventions like `feature/`, `fix/`, `main` vs `master`)

### 1.7 Read the detection guide

Read `PLUGIN_DIR/references/detection-guide.md` for the complete detection checklist. Use it to verify your findings and catch anything the steps above may have missed.

---

After completing all scan steps, summarize your findings before proceeding to Phase 2:

- **Language(s)** and version(s)
- **Framework(s)** (frontend, backend, styling, ORM, API)
- **Package manager**
- **Build tool**
- **Project pattern** (monorepo, standard app, library, Go standard layout, etc.)
- **Test framework(s)** (unit, E2E)
- **Linter(s) and formatter(s)**
- **CI/CD platform**
- **Database(s)**
- **Existing `.claude/` config** (if any)
- **Git conventions** (commit format, branch naming)
- **Available scripts/tasks**

---

## Phase 2: Generate Configuration

Using your scan findings from Phase 1, generate a tailored `.claude/` configuration for this project.

### 2.1 Read the generation guide

Read `PLUGIN_DIR/references/generation-guide.md` for guidelines on what good outputs look like. It contains principles, quality criteria, and examples from different stacks — use these as reference for quality, not as templates to fill.

### 2.2 Determine what to generate

Based on your Phase 1 findings, determine what to generate. The Output Requirements (section 9.7) define **mandatory outputs** — if a detection matches, the corresponding output MUST be generated. Then add anything extra this specific project needs beyond the minimum.

Follow the Output Requirements (section 9.7) — these are **hard requirements, not suggestions**:

| Layer | Rule |
|-------|------|
| `CLAUDE.md` | **Always generate** using the template in section 9.1. Under 200 lines. Every line must be project-specific. |
| `INSTRUCTION.md` | **Always generate** using the template in section 9.13. Under 150 lines. |
| Methodology skills | **Always generate** implement-feature, fix-bug, improve-architecture. **Generate when detected** (mandatory): tdd (tests), design-system (styling), api-patterns (backend), schema-patterns (DB/ORM). See section 9.2. |
| Workflow skills | **No mandatory workflow skills.** Select by detection + judgment. Use the catalog in section 9.2.2 as recommendations. If zero workflow skills are appropriate, justify in Phase 3. |
| Invocable skills | **Always generate** commit. **Conditional:** review (if git detected), others by judgment. See section 9.2. |
| Agents | **No mandatory agents.** Select agents that fit the project based on scan results + judgment. Use the Detection → Agent Mapping in section 9.4 as recommendations. Fetch from agency-agents and tailor — see section 9.4. If zero agents are appropriate, justify in Phase 3. |
| Hooks | Generate **only** when ALL 3 conditions are true: (1) tool binary confirmed installed via `command -v`, (2) command runs in under 30 seconds, (3) hook includes a disable comment. Use the exact format in section 9.5. |
| `.mcp.json` | Generate when frameworks detected benefit from MCP servers. Use the exact format in section 9.6. |

**Quality bar:** Every generated file must contain project-specific knowledge. If content feels generic, **refine it until it's specific** — do NOT skip or delete it. The minimum set in section 9.7 is mandatory.

### 2.3 Handle existing configuration

If the project already has `.claude/` config, follow these conflict resolution rules:

- **`CLAUDE.md` exists** → merge sections: keep all existing content, add only missing sections
- **`.claude/skills/` has directories** → skip existing skills, only generate new ones
- **`.claude/agents/` has files** → skip existing agents
- **`.claude/settings.json` exists** → merge hooks into existing settings (don't overwrite other settings)
- **`.mcp.json` exists** → merge servers (don't duplicate existing entries)

**Never overwrite existing configuration.**

### 2.4 Per-Layer Generation with Self-Review

Generate each layer in order. For each layer, compose → self-review → refine until robust before moving to the next. Each layer builds on the validated output of previous layers.

Follow the Composition Process (section 9.9), Workflow Connections (section 9.8), and Edge Case strategies (section 9.10) throughout. Use the Self-Review Criteria (section 9.12) for per-layer review. After all layers are complete, the Holistic Self-Improvement Loop runs the Quality Validation Checklist (section 9.11) and the Scoring Rubric (section 9.14) as the final cross-layer check.

#### Layer 1: CLAUDE.md (foundation)

Compose `CLAUDE.md` using the template in section 9.1. Then review:

- Does every section trace to a Phase 1 detection?
- Are build/test/lint commands the actual commands found in Phase 1?
- Is it under 200 lines? No generic advice?

Refine until solid. **This file is the foundation — skills and agents will reference it.**

#### Layer 2: Skills (methodology + workflow + invocable)

Generate ALL three skill types following [Anthropic's skill best practices](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md) (see section 9.2 for full guidelines). Every skill — regardless of type — must follow these Anthropic principles:

**Anthropic skill principles (non-negotiable):**

1. **Description is the trigger** — ~100 words, "pushy", "Use when..." pattern with 5+ action-verb trigger phrases. This is the ONLY thing Claude sees when deciding to activate.
2. **Progressive disclosure** — SKILL.md <500 lines. Use `references/` subdirectory for depth.
3. **Explain WHY** — Theory of mind reasoning, not rigid ALWAYS/NEVER rules.
4. **Lean instructions** — Every line must earn its place. Cut anything that doesn't change behavior.
5. **Exact output formats** — Precise templates with Input → Output examples from the actual project.
6. **No duplication with CLAUDE.md** — Skills = methodology, CLAUDE.md = facts.
7. **Evals required** — `evals/evals.json` with 2-3 realistic prompts + objectively verifiable assertions.

**For each skill type:**

**Methodology skills** — Auto-activate, teach how to think about recurring tasks. Structure: Why This Matters → Methodology (with WHY per step) → Examples (2+ I/O pairs) → Patterns → Anti-Patterns → Agent Reference.

**Workflow skills** — Auto-activate on complex multi-step tasks. Orchestrate named agents. Structure (inspired by [mattpocock/skills](https://github.com/mattpocock/skills) and [superpowers](https://github.com/obra/superpowers)):

- **Phases** (5-8 sequential steps) with verification gates between phases
- **Agent dispatch table** — which agent, which phase, what purpose (use exact agent names)
- **Vertical slices** — each increment cuts through ALL layers end-to-end, not horizontal layers
- **Common Mistakes** — document rationalization patterns agents use to skip steps
- **User validation checkpoints** — resolve decision dependencies one-by-one before proceeding

**Invocable skills** — User-invocable via `/skill-name`. Step-by-step guided workflows (migrated from commands). Include proper SKILL.md frontmatter with description.

**Self-review for each skill:**

- **Description check:** ~100 words with 5+ trigger phrases? "Pushy" enough?
- **WHY check:** Instructions explain reasoning, not just rigid MUSTs?
- **Examples check:** At least 2 Input/Output pairs from the actual project?
- **Size check:** SKILL.md under 500 lines?
- **Duplication check:** No overlap with CLAUDE.md content?
- **Evals check:** `evals/evals.json` has 2-3 prompts with discriminating assertions?
- **Workflow check (workflow skills only):** Agent dispatch table present? Verification gates? Common Mistakes section?
- **Connection check:** References which agent(s) it dispatches or works with?

Refine until each skill is project-specific, follows Anthropic best practices, and is connected to Layer 1.

#### Layer 3: Agents (Fetch & Tailor)

> **Agents MUST be fetched from agency-agents via `curl -s`. Writing from scratch is FORBIDDEN unless curl returns 404.**

**Step 1: Select** — Check the Output Requirements (section 9.7) against Phase 1 detections. Use the Detection → Agent Mapping in section 9.4 as recommendations. Also check which agents are referenced by workflow skills from Layer 2 — if a workflow skill dispatches an agent by name, that agent MUST be generated.

**Step 2: Fetch ALL agents first (before writing any files)** — Run `curl -s` via **Bash** for EVERY selected agent. Do this as a batch before writing any agent files. Do **NOT** use WebFetch or Fetch (they process content through an AI model and return summaries, not raw files).

Fetch all agents in parallel by redirecting each to a temp file:

```bash
curl -s https://raw.githubusercontent.com/msitarzewski/agency-agents/main/engineering/engineering-software-architect.md > /tmp/agent-architect.md &
curl -s https://raw.githubusercontent.com/msitarzewski/agency-agents/main/product/product-manager.md > /tmp/agent-pm.md &
curl -s https://raw.githubusercontent.com/msitarzewski/agency-agents/main/engineering/engineering-code-reviewer.md > /tmp/agent-reviewer.md &
# ... add all selected agents with consistent naming: /tmp/agent-{name}.md
wait
```

Refer to the agency-agents Repository Structure in section 9.4 of the generation guide for correct `{category}/{filename}` paths.

**CHECKPOINT — Verify before proceeding to Step 3:**

```bash
head -1 /tmp/agent-*.md
```

- Every file must start with `---` (YAML frontmatter). Any file showing "404: Not Found" or empty = failed fetch.
- Did you run `curl -s` for every selected agent? If not, go back and run the missing ones.
- Only agents that failed may be composed from scratch. Do NOT proceed to writing files until all curl commands have been executed.

**Step 3: Write each fetched agent to disk, then tailor in-place** — For each successfully fetched agent:

1. **Read the fetched content from `/tmp/agent-{name}.md`**, then **Write it to `.claude/agents/{name}.md`** using the Write tool. The file content must be:
   - Claude Code frontmatter (description, model, allowed-tools, isolation) at the very top
   - Then the **COMPLETE** raw markdown from curl output, unchanged
2. **Then use the Edit tool to make targeted revisions** — do NOT use Write again (that would overwrite the entire file). Use Edit to make surgical changes:
   - Replace generic framework references with this project's specific technologies
   - Add actual file paths, directories, patterns from Phase 1
   - Add project-specific patterns found during scan
   - Adjust success metrics to match the project's actual tools
   - Add workflow connections to skills from Layer 2
3. **Preserve the original depth** — the fetched agents are 200-400 lines of production expertise. Your revised version must keep most of that depth. Do NOT summarize or condense — only revise in-place.

**Step 4: Self-review** — For each tailored agent:

- **Provenance check:** Was this agent fetched via `curl -s`? If not, this is a failure — go back to Step 2.
- Does it embed stack-intersection knowledge (not just the original generic content)?
- Does the process reference actual patterns from CLAUDE.md and Layer 2?
- Is it consistent with skills from Layer 2?
- **Depth check:** Is the agent at least 80 lines with all 7 sections? If not, add more project-specific knowledge.
- **Stack Expertise longest:** Is the Stack Expertise section the longest section in the agent? This is where project-specific knowledge lives.
- **Specificity test:** Remove the project name — can you still identify which stack this targets?
- **Connection check:** Does it reference which skill(s) it follows and which workflow skill(s) dispatch it? (See section 9.8)

Refine until each agent is genuinely stack-specific, deeply knowledgeable, and connected to all previous layers.

**Fallback (ONLY for individual agents where curl returned 404/empty):** Compose that one agent from scratch using section 9.4 guidelines. You must still meet the minimum 80-line depth and all quality criteria. If you are writing ALL agents from scratch, something went wrong — go back to Step 2 and run the curl commands.

#### Layer 4: Hooks + MCP

Generate hooks and MCP config using exact formats from sections 9.5/9.6. Verify:

- Hook commands match the lint/test commands in CLAUDE.md
- Binary confirmed installed (Phase 1 `command -v` check)
- MCP servers match detected frameworks

#### Layer 5: INSTRUCTION.md

Generate using the template from the generation guide. This is a quick-start onboarding guide, not documentation. If one already exists, skip this layer.

Composition constraints for this layer:

- Include only sections for layers that were actually generated (skills, agents, hooks, MCP)
- Fill in all project-specific values — stack names, framework versions, real commands
- Add 3–5 tips specific to the developer's detected stack
- Keep it under 150 lines
- Use a friendly, conversational tone

Verify it accurately summarizes everything generated in Layers 1-4.

#### Holistic Self-Improvement Loop

All layers are now composed with per-layer self-review complete. Before presenting results, evaluate all generated outputs **as a holistic system** and iteratively improve them until they meet quality thresholds. Reference the Self-Improvement Scoring Rubric (section 9.14 of the generation guide) for the 10 evaluation dimensions and their scoring criteria.

**For each iteration (max 5 rounds), follow this procedure:**

**Step 1: Sleep trigger** — Execute this Bash command to create a forced evaluation breakpoint:

```bash
sleep 5 && echo "=== SELF-IMPROVEMENT CHECKPOINT (round N/5) ==="
```

Replace `N` with the current round number. After seeing the echo output, switch from generation mode to **critical evaluation mode**. Do NOT treat this as a continuation of generation — you are now an evaluator, not a creator.

**Step 2: Read back ALL generated files** — Use the Read tool to re-read every file written during Phase 2. This is mandatory — do NOT rely on memory of what you wrote. Memory is unreliable after generating 20+ files.

**Step 3: Score all 10 dimensions** — Using the rubric in section 9.14, evaluate each dimension with a score from 0–10. For each dimension, perform the specified **verification action** (reading files, counting lines, comparing values). Record the score and a brief note explaining the rating.

Present the current round's scores in a table:

```
Round N scores:
| # | Dimension            | Score | Notes                          |
|---|----------------------|-------|--------------------------------|
| 1 | Completeness         | ?/10  | ...                            |
| 2 | Specificity          | ?/10  | ...                            |
| 3 | Accuracy             | ?/10  | ...                            |
| 4 | Cross-layer Consistency | ?/10 | ...                           |
| 5 | Depth                | ?/10  | ...                            |
| 6 | Coverage             | ?/10  | ...                            |
| 7 | Non-redundancy       | ?/10  | ...                            |
| 8 | Actionability        | ?/10  | ...                            |
| 9 | Safety               | ?/10  | ...                            |
| 10| Freshness            | ?/10  | ...                            |
```

**Step 4: Check stop conditions** — Stop the loop if ANY of these are true:

- **Threshold met:** All 10 dimensions score ≥ 8
- **Stalled:** Two consecutive rounds where no dimension's score improved
- **Max iterations:** Round 5 reached

Record the convergence reason for the Phase 3 score card.

**Step 5: Fix all failing dimensions** — If not stopping, use the Edit tool to fix issues for **every** dimension scoring below 8. Batch all fixes in a single round before re-evaluating. Do NOT fix one dimension and re-score — fix them all, then loop back to Step 1.

**What to track across rounds:**

- Running score card (dimension × round → score)
- What was changed in each round (brief description per fix)
- Convergence reason when the loop ends

**Critical instructions:**

- Do NOT skip the sleep trigger — it is the mechanism that forces a genuine evaluation pause
- Do NOT score dimensions without reading the actual files — memory is unreliable after generating many files
- Do NOT delete files that score low — refine them until they score ≥ 8
- If a dimension is stuck below 8 for 2 consecutive rounds, note it as a known limitation and move on
- Reference the Quality Validation Checklist (section 9.11) as the source of truth for pass/fail criteria within each dimension

---

## Phase 3: Present Results

After the Self-Improvement Loop completes and all files pass quality validation, present a clear summary.

### 3.1 List every generated file grouped by layer

1. **CLAUDE.md** — show the file path
2. **Methodology skills** — list each skill name with its description
3. **Workflow skills** — list each with its phases and which agents it dispatches
4. **Invocable skills** — list each as `/skill-name` with its one-line description
5. **Agents** — list each with its isolation mode and what stack-specific knowledge it embeds
6. **Hooks** — list each with its lifecycle event
7. **MCP servers** — list each server added to `.mcp.json`
8. **INSTRUCTION.md** — mention where to find the onboarding guide

### 3.2 Explain why each was generated (and why items were skipped)

For every generated item, state which Phase 1 detection triggered it:

- `developer` agent → "Next.js + Prisma + Jest detected — agent embeds RSC/Prisma intersection patterns"
- `feature-development` workflow skill → "Full-stack app with 4+ layers detected — orchestrates vertical slice implementation with developer + reviewer agents"
- `design-system` methodology skill → "Tailwind CSS + shadcn/ui detected in devDependencies"

If zero agents or zero workflow skills were generated, explain why none are appropriate for this project.

### 3.3 Flag hooks with warnings

For each generated hook, warn that it runs automatically and explain how to disable it (which entry to remove from `.claude/settings.json`).

### 3.4 Quality Score Card

Present the final score card from the Holistic Self-Improvement Loop as a markdown table:

```
### Quality Score Card

| # | Dimension              | Score | Notes                              |
|---|------------------------|-------|------------------------------------|
| 1 | Completeness           | ?/10  | ...                                |
| 2 | Specificity            | ?/10  | ...                                |
| 3 | Accuracy               | ?/10  | ...                                |
| 4 | Cross-layer Consistency | ?/10 | ...                                |
| 5 | Depth                  | ?/10  | ...                                |
| 6 | Coverage               | ?/10  | ...                                |
| 7 | Non-redundancy         | ?/10  | ...                                |
| 8 | Actionability          | ?/10  | ...                                |
| 9 | Safety                 | ?/10  | ...                                |
| 10| Freshness              | ?/10  | ...                                |
|   | **Total**              | **?/100** | **Converged in N round(s)** |
```

Include after the table:

- **Rounds completed:** How many self-improvement rounds ran
- **Improvements per round:** Brief bullet list of what was fixed in each round
- **Convergence reason:** Why the loop stopped (all dimensions ≥ 8 / no improvement for 2 rounds / max 5 rounds reached)
- **Known limitations:** Any dimensions that remained below 8 despite improvement attempts

### 3.5 Customization note

End with:

> Everything generated is yours to edit. To re-run with different settings, use `/project-architect` again — it merges with existing config, never overwrites. To add skills or agents manually, create files in `.claude/skills/` or `.claude/agents/`.

Do NOT ask questions. Do NOT prompt for feedback. The command is complete.

---

## Key Principles

- **Detect, don't assume** — every generated line traces to a detected file
- **Specificity over generality** — no lines that could apply to any project
- **Autonomous completion** — generate → self-review → refine → until robust, without asking
- **Composability** — deleting any generated file breaks nothing else
- **Safety first for hooks** — when in doubt, don't generate the hook
- **Less is more** — five excellent customizations > twenty generic ones
- **Anthropic skill standards** — every skill follows the official skill-creator principles
