# Contributing Guide

## Rules
- Do NOT push directly to `main`.
- Work on feature branches, then open a Pull Request (PR).
- A PR must pass CI (Flutter CI) + 1 approval before merging.

## Branch naming
- feature/<area>-<short>
- fix/<area>-<short>

Examples:
- feature/nav-bottom-shell
- feature/test-flow
- fix/theme-deprecation

## Before opening a PR
Run:
- dart format .
- flutter pub get
- flutter analyze
- flutter test

## Commit messages
Use simple prefixes:
- feat: ...
- fix: ...
- chore: ...
- docs: ...
- refactor: ...

## PR checklist
- CI is green
- No broken imports
- Screenshots for UI changes (if applicable)
