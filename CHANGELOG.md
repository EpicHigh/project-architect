# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Plugin manifest (`.claude-plugin/plugin.json`)
- Main `/project-architect` command with 4-phase workflow (Scan, Generate, Present, Iterate)
- `project-scanner` bridging skill for auto-activation
- Detection guide covering 16 categories of technology detection
- Generation guide with templates for CLAUDE.md, 12 commands, 6 skills, 3 agents, hooks, and MCP
- Selection matrix mapping detections to generated outputs
- Test fixtures for 5 stacks (react-next-app, go-api-server, python-fastapi, nx-monorepo, empty-project)
- Example outputs for 3 stacks (react-nextjs, go-api, python-fastapi)
- GitHub Actions CI workflow with markdown linting
- README, CONTRIBUTING, and ARCHITECTURE documentation
- GitHub issue templates (bug report, feature request, new stack support)
- PR template with contribution checklist
