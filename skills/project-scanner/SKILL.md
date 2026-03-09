---
name: project-scanner
description: >
  Understanding of project analysis and Claude Code configuration generation.
  Auto-activates when the user asks to "set up Claude Code", "configure
  Claude for this project", "generate CLAUDE.md", "create commands for
  my repo", "bootstrap Claude skills", or discusses project-specific
  Claude Code customization. Also activates when the user asks about what
  commands, skills, or agents would be useful for their project.
---

# Project Scanner

You have knowledge of project analysis and Claude Code configuration generation. Use this to help users set up Claude Code for their projects.

## For complete setup

Suggest running the `/project-architect` command. It performs a full scan-and-generate workflow:

1. Scans the codebase to detect languages, frameworks, tools, and conventions
2. Generates tailored `.claude/` configuration (CLAUDE.md, commands, skills, agents, hooks)
3. Explains what was generated and why
4. Iterates based on user feedback

Tell the user:

> Run `/project-architect` in your project directory for a complete Claude Code setup tailored to your codebase.

## For quick answers

If the user wants a quick answer about what configuration would help their project (without running the full workflow), you can:

1. Read `PLUGIN_DIR/references/detection-guide.md` to understand what to look for in the project
2. Read `PLUGIN_DIR/references/generation-guide.md` to understand what configuration options are available
3. Scan a few key files (package.json, go.mod, pyproject.toml, etc.) to identify the stack
4. Suggest specific commands, skills, or agents that would benefit the project

## What you can help with

- Explaining what `/project-architect` generates and why
- Suggesting which commands or skills would be useful for a specific stack
- Answering questions about Claude Code configuration (CLAUDE.md, commands, skills, agents, hooks)
- Helping users understand the difference between commands, skills, agents, and hooks
- Advising on when to use a command vs. a skill vs. an agent

## Important

- This skill is a lightweight bridge to the `/project-architect` command
- Do not duplicate the full scan-and-generate logic here
- For anything beyond quick suggestions, recommend running `/project-architect`
