---
description: Analyze your codebase and generate Claude Code configuration (CLAUDE.md, commands, skills, agents, hooks)
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

- `.claude/` directory (commands, skills, agents, settings.json)
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
| Commands | **Always generate** commit, implement, fix, review. **Generate when detected** (mandatory): optimize-db (DB/ORM), security-audit (backend). See section 9.2. |
| Skills | **Always generate** implement-feature, fix-bug, improve-architecture. **Generate when detected** (mandatory): tdd (tests), design-system (styling), api-patterns (backend), schema-patterns (DB/ORM). See section 9.3. |
| Agents | **Always generate** architect, product-manager, code-reviewer. **Generate when detected** (mandatory, not optional): see section 9.7 for full mapping. Fetch from agency-agents and tailor — see section 9.4. |
| Hooks | Generate **only** when ALL 3 conditions are true: (1) tool binary confirmed installed via `command -v`, (2) command runs in under 30 seconds, (3) hook includes a disable comment. Use the exact format in section 9.5. |
| `.mcp.json` | Generate when frameworks detected benefit from MCP servers. Use the exact format in section 9.6. |

**Quality bar:** Every generated file must contain project-specific knowledge. If content feels generic, **refine it until it's specific** — do NOT skip or delete it. The minimum set in section 9.7 is mandatory.

### 2.3 Handle existing configuration

If the project already has `.claude/` config, follow these conflict resolution rules:

- **`CLAUDE.md` exists** → merge sections: keep all existing content, add only missing sections
- **`.claude/commands/` has files** → skip existing commands, only generate new ones
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

Refine until solid. **This file is the foundation — commands, skills, and agents will reference it.**

#### Layer 2: Commands

Compose all commands (universal + conditional). Then review each command:

- Does every validation step use a real command from CLAUDE.md?
- Are steps consistent with what CLAUDE.md documents?
- **Connection check:** Does each command reference the agent that handles the same workflow in isolation? (e.g., `/implement` should mention the `developer` agent)

Refine until each command is project-specific and connected to Layer 1.

#### Layer 3: Skills

Compose all skills following [Anthropic's skill best practices](https://github.com/anthropics/skills/tree/main/skills/skill-creator) (see section 9.3 for full guidelines). For each skill:

**Step 1: Write SKILL.md** — Follow the SKILL.md anatomy in section 9.3. Key requirements:

- Description must be ~100 words and "pushy" — explicitly state WHEN to activate with 5+ action-verb trigger phrases
- Instructions must explain WHY (theory of mind), not just rigid rules
- Include at least 2 concrete Input/Output examples from the actual project
- Keep under 500 lines

**Step 2: Write evals** — Generate `evals/evals.json` with 2-3 realistic test prompts and objectively verifiable assertions. Prompts should be what a real developer would type. Assertions must discriminate (fail when skill fails, pass when it succeeds).

**Step 3: Self-review** — For each skill:

- **Description check:** Is it ~100 words with 5+ trigger phrases? Is it "pushy" enough to combat under-triggering?
- **WHY check:** Do instructions explain reasoning, or just list rigid MUSTs?
- **Examples check:** Are there at least 2 Input/Output pairs from the actual project?
- **Size check:** Is SKILL.md under 500 lines?
- **Duplication check:** Does it avoid repeating CLAUDE.md content?
- **Evals check:** Does `evals/evals.json` have 2-3 prompts with discriminating assertions?
- **Connection check:** Does it reference which agent(s) apply it?

Refine until each skill is project-specific, follows Anthropic best practices, and is connected to Layers 1-2.

#### Layer 4: Agents (Fetch & Tailor)

> **Agents MUST be fetched from agency-agents via `curl -s`. Writing from scratch is FORBIDDEN unless curl returns 404.**

**Step 1: Select** — Check the Output Requirements (section 9.7) against Phase 1 detections. Every agent in the "Always Generate" and "Generate When Detected" tables that matches a detection is **mandatory**. Also check the mapping table in section 9.4 for fetch URLs.

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
   - Add actual file paths, directories, commands from Phase 1
   - Add project-specific patterns found during scan
   - Adjust success metrics to match the project's actual tools
   - Add workflow connections to commands and skills from Layers 2-3
3. **Preserve the original depth** — the fetched agents are 200-400 lines of production expertise. Your revised version must keep most of that depth. Do NOT summarize or condense — only revise in-place.

**Step 4: Self-review** — For each tailored agent:

- **Provenance check:** Was this agent fetched via `curl -s`? If not, this is a failure — go back to Step 2.
- Does it embed stack-intersection knowledge (not just the original generic content)?
- Does the process reference actual commands from CLAUDE.md and Layer 2?
- Is it consistent with skills from Layer 3?
- **Depth check:** Is the agent at least 80 lines with all 7 sections? If not, add more project-specific knowledge.
- **Stack Expertise longest:** Is the Stack Expertise section the longest section in the agent? This is where project-specific knowledge lives.
- **Specificity test:** Remove the project name — can you still identify which stack this targets?
- **Connection check:** Does it reference which skill(s) it follows and which command(s) it complements? (See section 9.8)

Refine until each agent is genuinely stack-specific, deeply knowledgeable, and connected to all previous layers.

**Fallback (ONLY for individual agents where curl returned 404/empty):** Compose that one agent from scratch using section 9.4 guidelines. You must still meet the minimum 80-line depth and all quality criteria. If you are writing ALL agents from scratch, something went wrong — go back to Step 2 and run the curl commands.

#### Layer 5: Hooks + MCP

Generate hooks and MCP config using exact formats from sections 9.5/9.6. Verify:

- Hook commands match the lint/test commands in CLAUDE.md
- Binary confirmed installed (Phase 1 `command -v` check)
- MCP servers match detected frameworks

#### Layer 6: INSTRUCTION.md

Generate using the template from the generation guide. This is a quick-start onboarding guide, not documentation. If one already exists, skip this layer.

Composition constraints for this layer:

- Include only sections for layers that were actually generated (commands, skills, agents, hooks, MCP)
- Fill in all project-specific values — stack names, framework versions, real command names
- Add 3–5 tips specific to the developer's detected stack
- Keep it under 150 lines
- Use a friendly, conversational tone

Verify it accurately summarizes everything generated in Layers 1-5.

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
2. **Commands** — list each as `/command-name` with its one-line description
3. **Skills** — list each skill name with its description
4. **Agents** — list each with its isolation mode and what stack-specific knowledge it embeds
5. **Hooks** — list each with its lifecycle event
6. **MCP servers** — list each server added to `.mcp.json`
7. **INSTRUCTION.md** — mention where to find the onboarding guide

### 3.2 Explain why each was generated

For every generated item, state which Phase 1 detection triggered it:

- `developer` agent → "Next.js + Prisma + Jest detected — agent embeds RSC/Prisma intersection patterns"
- `design-system` skill → "Tailwind CSS + shadcn/ui detected in devDependencies"

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
- **Improvements per round:** Brief bullet list of what was fixed in each round (e.g., "Round 1: Added Prisma intersection knowledge to developer agent, fixed lint command in review command")
- **Convergence reason:** Why the loop stopped (all dimensions ≥ 8 / no improvement for 2 rounds / max 5 rounds reached)
- **Known limitations:** Any dimensions that remained below 8 despite improvement attempts

### 3.5 Customization note

End with:

> Everything generated is yours to edit. To re-run with different settings, use `/project-architect` again — it merges with existing config, never overwrites. To add commands, skills, or agents manually, create files in `.claude/commands/`, `.claude/skills/`, or `.claude/agents/`.

Do NOT ask questions. Do NOT prompt for feedback. The command is complete.

---

## Key Principles

- **Detect, don't assume** — every generated line traces to a detected file
- **Specificity over generality** — no lines that could apply to any project
- **Autonomous completion** — generate → self-review → refine → until robust, without asking
- **Composability** — deleting any generated file breaks nothing else
- **Safety first for hooks** — when in doubt, don't generate the hook
- **Less is more** — five excellent customizations > twenty generic ones
