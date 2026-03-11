# Architecture

## Core Insight

**This is not a program. It's structured instructions for Claude Code.**

project-architect has no runtime, no dependencies, no build step. It's pure markdown and JSON. Claude Code reads these files, follows the instructions, and generates configuration tailored to whatever project it's pointed at.

Claude is the program. The markdown is the source code.

## The Four Files

The entire plugin is 4 files:

```
.claude-plugin/plugin.json          Entry point — tells Claude Code this is a plugin
commands/project-architect.md        The command — 4-phase workflow Claude follows
references/detection-guide.md        Knowledge base — what to look for during scanning
references/generation-guide.md       Template catalog — what to generate from detections
```

**plugin.json** registers the plugin and points to the command and skill files. It's the only JSON file.

**project-architect.md** is the main slash command. It contains instructions for Claude to execute in 4 phases: Scan, Generate, Present, Iterate. It references both guide files and tells Claude which tools to use (Read, Glob, Grep, Bash, Write).

**detection-guide.md** is a structured knowledge base of ~440 lines. It contains tables mapping indicator files to technologies — "if you see `package.json` with `next` in dependencies, that's Next.js." Claude reads this during Phase 1 to know what to look for.

**generation-guide.md** is a template catalog of ~1300 lines. It contains templates for every output file the plugin can generate — CLAUDE.md, commands, skills, agents, hooks, MCP config. Each template has trigger conditions tied to Phase 1 detections. A selection matrix at the end maps all detections to outputs.

## How It Works

```
User runs /project-architect
         │
         ▼
┌─────────────────────┐
│  Phase 1: Scan      │  Read config files, directory structure, git history
│                     │  Reference: detection-guide.md
│                     │  Tools: Read, Glob, Grep, Bash (read-only)
└────────┬────────────┘
         │ detections
         ▼
┌─────────────────────┐
│  Phase 2: Generate  │  Match detections to templates, produce output
│                     │  Reference: generation-guide.md
│                     │  Tools: Write
└────────┬────────────┘
         │ generated files
         ▼
┌─────────────────────┐
│  Phase 3: Present   │  Show user what was generated and why
│                     │  No tools — just conversation
└────────┬────────────┘
         │ user feedback
         ▼
┌─────────────────────┐
│  Phase 4: Iterate   │  Refine based on feedback
│                     │  Tools: Read, Write
└─────────────────────┘
```

## Why This Architecture

**Zero dependencies.** No npm install, no Python environment, no build step. Clone it and it works.

**Claude is the engine.** Instead of writing a parser, a template engine, and a CLI, we write instructions that Claude follows. Claude already knows how to read files, understand code, and write markdown. We just tell it what to look for and what to produce.

**Naturally extensible.** Adding support for a new framework means adding rows to a markdown table and a template to a markdown file. No code to compile, no tests to update (beyond fixtures), no APIs to learn.

**Conflict-safe.** The command instructs Claude to merge with existing configuration, never overwrite. If you already have a `.claude/commands/commit.md`, the plugin detects it and skips or merges.

## Design Principles

1. **Detect, don't assume.** Every generated line traces back to something detected in Phase 1. If the scanner didn't find it, the generator doesn't produce it.

2. **No executable code.** The plugin never runs project code, installs dependencies, or executes builds. Phase 1 is strictly read-only.

3. **Merge, never overwrite.** If configuration already exists, the plugin merges new content with existing files. User work is never destroyed.

4. **Safety conditions for hooks.** Hooks (pre-commit scripts) require 3 conditions before generation: binary confirmed installed, runs under 30 seconds, includes a disable comment.

5. **Agent generation criteria.** Agents require 3 conditions: benefits from separate context, modifies conflicting files, has validation tooling available.

## The Six Output Layers

The plugin generates up to 6 layers of configuration:

| Layer | Location | Purpose |
| --- | --- | --- |
| CLAUDE.md | Project root | Project overview, build/test/lint commands, conventions |
| Commands | `.claude/commands/*.md` | Slash commands for common workflows |
| Skills | `.claude/skills/*/SKILL.md` | Auto-activated contextual knowledge |
| Agents | `.claude/agents/*.md` | Autonomous sub-agents for complex tasks |
| Hooks | `.claude/settings.json` | Pre-commit hooks for linting/testing |
| MCP | `.mcp.json` | Model Context Protocol server connections |

Not every project gets all 6. The selection matrix in generation-guide.md determines which outputs are produced based on what was detected.

## Extending the Plugin

Adding support for a new stack is a markdown editing task:

1. **Detection** — Add rows to tables in `references/detection-guide.md`
2. **Generation** — Add templates to `references/generation-guide.md` and update the selection matrix
3. **Testing** — Add a config-only fixture to `tests/fixtures/`
4. **Example** — Generate sample output in `examples/`
5. **README** — Add the stack to the supported list

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.
