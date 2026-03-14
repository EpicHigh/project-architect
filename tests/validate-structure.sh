#!/bin/bash
# End-to-end structural validation for project-architect plugin
# Validates fixtures, examples, cross-references, and selection matrix consistency

set -e

PASS=0
FAIL=0
WARN=0

pass() { echo "  ✓ $1"; PASS=$((PASS + 1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  ⚠ $1"; WARN=$((WARN + 1)); }

check_file() {
  if [ -f "$1" ]; then pass "$1 exists"; else fail "$1 missing"; fi
}

check_dir() {
  if [ -d "$1" ]; then pass "$1/ exists"; else fail "$1/ missing"; fi
}

echo "=== Test Fixtures ==="

echo ""
echo "--- react-next-app ---"
check_file tests/fixtures/react-next-app/package.json
check_file tests/fixtures/react-next-app/tsconfig.json
check_file tests/fixtures/react-next-app/next.config.js
check_file tests/fixtures/react-next-app/tailwind.config.ts
check_file tests/fixtures/react-next-app/jest.config.ts
check_file tests/fixtures/react-next-app/.eslintrc.json
check_file tests/fixtures/react-next-app/prisma/schema.prisma
check_dir tests/fixtures/react-next-app/app
check_dir tests/fixtures/react-next-app/components
check_dir tests/fixtures/react-next-app/lib

echo ""
echo "--- go-api-server ---"
check_file tests/fixtures/go-api-server/go.mod
check_file tests/fixtures/go-api-server/.golangci.yml
check_file tests/fixtures/go-api-server/Makefile
check_dir tests/fixtures/go-api-server/cmd/server
check_dir tests/fixtures/go-api-server/internal
check_dir tests/fixtures/go-api-server/pkg

echo ""
echo "--- python-fastapi ---"
check_file tests/fixtures/python-fastapi/pyproject.toml
check_file tests/fixtures/python-fastapi/pytest.ini
check_dir tests/fixtures/python-fastapi/app
check_dir tests/fixtures/python-fastapi/tests

echo ""
echo "--- nx-monorepo ---"
check_file tests/fixtures/nx-monorepo/package.json
check_file tests/fixtures/nx-monorepo/nx.json
check_file tests/fixtures/nx-monorepo/pnpm-workspace.yaml
check_dir tests/fixtures/nx-monorepo/apps
check_dir tests/fixtures/nx-monorepo/packages

echo ""
echo "--- empty-project ---"
check_file tests/fixtures/empty-project/README.md

echo ""
echo "=== Example Outputs ==="

echo ""
echo "--- react-nextjs ---"
check_file examples/react-nextjs/CLAUDE.md
check_file examples/react-nextjs/INSTRUCTION.md
check_file examples/react-nextjs/.mcp.json
check_file examples/react-nextjs/.claude/settings.json
for cmd in commit review explain component page migrate test; do
  check_file "examples/react-nextjs/.claude/commands/${cmd}.md"
done
for skill in code-conventions project-context design-system schema-patterns test-patterns; do
  check_dir "examples/react-nextjs/.claude/skills/${skill}"
done
check_file examples/react-nextjs/.claude/agents/test-writer.md

echo ""
echo "--- go-api ---"
check_file examples/go-api/CLAUDE.md
check_file examples/go-api/.claude/settings.json
for cmd in commit review explain endpoint migrate; do
  check_file "examples/go-api/.claude/commands/${cmd}.md"
done
for skill in code-conventions project-context api-patterns schema-patterns; do
  check_dir "examples/go-api/.claude/skills/${skill}"
done

echo ""
echo "--- python-fastapi ---"
check_file examples/python-fastapi/CLAUDE.md
check_file examples/python-fastapi/.mcp.json
check_file examples/python-fastapi/.claude/settings.json
for cmd in commit review explain endpoint migrate test; do
  check_file "examples/python-fastapi/.claude/commands/${cmd}.md"
done
for skill in code-conventions project-context api-patterns schema-patterns test-patterns; do
  check_dir "examples/python-fastapi/.claude/skills/${skill}"
done
check_file examples/python-fastapi/.claude/agents/test-writer.md

echo ""
echo "=== Plugin Manifest ==="
check_file .claude-plugin/plugin.json
check_file .claude-plugin/marketplace.json

# Version consistency check
PLUGIN_VERSION=$(node -e "console.log(require('./.claude-plugin/plugin.json').version)")
MARKET_VERSION=$(node -e "console.log(require('./.claude-plugin/marketplace.json').plugins[0].version)")
if [ "$PLUGIN_VERSION" = "$MARKET_VERSION" ]; then
  pass "Version match: plugin=$PLUGIN_VERSION marketplace=$MARKET_VERSION"
else
  fail "Version mismatch: plugin=$PLUGIN_VERSION marketplace=$MARKET_VERSION"
fi

echo ""
echo "=== Core Files ==="
check_file commands/project-architect.md
check_file skills/project-scanner/SKILL.md
check_file references/detection-guide.md
check_file references/generation-guide.md

echo ""
echo "=== Documentation ==="
check_file README.md
check_file CONTRIBUTING.md
check_file ARCHITECTURE.md
check_file LICENSE
check_file CODE_OF_CONDUCT.md
check_file CHANGELOG.md

echo ""
echo "=== INSTRUCTION.md Checks ==="
INSTRUCTION_LINES=$(wc -l < examples/react-nextjs/INSTRUCTION.md | tr -d ' ')
if [ "$INSTRUCTION_LINES" -lt 150 ]; then
  pass "INSTRUCTION.md is under 150 lines ($INSTRUCTION_LINES lines)"
else
  fail "INSTRUCTION.md exceeds 150 lines ($INSTRUCTION_LINES lines)"
fi

echo ""
echo "=== Results ==="
echo "  Passed: $PASS"
echo "  Failed: $FAIL"
echo "  Warnings: $WARN"

if [ $FAIL -gt 0 ]; then
  echo ""
  echo "VALIDATION FAILED"
  exit 1
fi

echo ""
echo "ALL CHECKS PASSED"
