---
description: Create a guided commit following project conventions
allowed-tools: Bash, Read, Grep, Glob
---

# Guided Commit

## Steps

1. Run `git status` and `git diff --staged` to review changes.
2. If nothing is staged, show unstaged changes and ask what to stage.
3. Write a commit message following project conventions:
4. Run `git commit` with the message.
5. Show the commit hash and summary.

## Pre-commit Check

Run `make lint` before committing. If it fails, show errors and ask to fix or skip.
