# Contributing to project-architect

Thanks for your interest in contributing! This project is **all markdown and JSON** — no build tools, no compiled code, no runtime dependencies. If you can write markdown, you can contribute.

## Ways to Contribute

- **Add a new stack** — detection entries + generation examples for a new language/framework
- **Improve guidelines** — better examples, quality criteria, edge case handling
- **Add examples** — generated output for stacks not yet covered
- **Fix bugs** — incorrect detections, missing edge cases, quality gaps
- **Improve docs** — typos, clarity, missing information

## How the Plugin Works

project-architect is a 4-file architecture:

```
.claude-plugin/plugin.json        → Plugin manifest (entry point)
commands/project-architect.md      → Main slash command (4 phases: Scan → Generate → Present → Iterate)
references/detection-guide.md      → Tables mapping indicator files → technologies
references/generation-guide.md     → Guidelines, examples, and quality criteria for output composition
```

Claude Code is the runtime. The command file tells Claude what to scan (using detection-guide.md) and how to compose outputs (using generation-guide.md as reference, not as templates to fill). There is no executable code.

## Adding a New Stack

This is the most common contribution. Follow these 5 steps:

### 1. Add detection entries

Edit `references/detection-guide.md` and add rows to the appropriate tables:

- **Language table (8.1)** — indicator file, version source
- **Framework table (8.2)** — indicator file or dependency, category
- Add entries to other tables as needed (package managers, build tools, testing, etc.)

### 2. Add generation examples

Edit `references/generation-guide.md`:

- Add examples showing how the new stack's outputs should look (section 9.2 for commands, 9.3 for skills, 9.4 for agents)
- Update the Output Reasoning Guide (section 9.7) if new detection → output mappings are needed
- Add edge case handling to section 9.9 if the stack has unique requirements

### 3. Add a test fixture

Create a directory under `tests/fixtures/<stack-name>/` with config files only (no application code):

- Package manifest (package.json, go.mod, pyproject.toml, etc.)
- Config files (tsconfig.json, .eslintrc, etc.)
- Directory stubs with `.gitkeep` for expected project structure

See existing fixtures in `tests/fixtures/` for reference.

### 4. Generate example output

Create a directory under `examples/<stack-name>/` with the complete generated output:

- `CLAUDE.md`
- `.claude/commands/` with all applicable command files
- `.claude/skills/` with all applicable skill directories
- `.claude/agents/` if applicable
- `.claude/settings.json` if hooks are generated
- `.mcp.json` if MCP servers are generated

### 5. Update README

Add the new stack to the Supported Stacks section in `README.md`.

## Writing Good Examples

When adding examples to the generation guide:

- **Show stack intersections** — demonstrate knowledge of how technologies interact, not just individual framework docs
- **Be specific** — reference actual tools, file paths, and conventions the stack uses
- **Test with the plugin** — run `/project-architect` against your fixture to verify output quality
- **Demonstrate quality bar** — examples set the standard Claude aims for when composing project-specific outputs

## Testing Locally

Install the plugin locally and run it against test fixtures:

```sh
# Run Claude Code with the plugin loaded
claude --plugin-dir .
```

Then inside Claude Code, navigate to a test fixture and run the command:

```
cd tests/fixtures/react-next-app
/project-architect
```

Verify that:

- All expected files are detected correctly
- Generated output matches what you'd expect for that stack
- No placeholder variables remain in the output

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add detection for deno runtime
fix: correct prisma version source path
docs: update supported stacks in readme
chore: add flutter test fixture
```

- Use lowercase subject lines
- Use imperative mood: "add", "fix", "update" — not "added", "fixes"
- Keep the subject line under 72 characters
- One-line commits by default — only add a body for non-obvious changes

## Pull Request Process

1. Fork the repo and create a branch from `main`
2. Make your changes following the guidelines above
3. Ensure markdown linting passes (CI runs markdownlint-cli2)
4. Open a PR with a clear title and description
5. CodeRabbit will review automatically — address valid feedback
6. A maintainer will review and merge

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you agree to uphold this code. Report unacceptable behavior to the maintainers.
