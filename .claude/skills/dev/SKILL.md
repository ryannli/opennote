---
name: dev
description: Enter development mode — work on the OpenNote repo itself, not as a note app
user_invocable: true
---

# /dev — Development Mode

Switch context from note-taking to developing the OpenNote repo itself.

## Instructions

When this skill is invoked, tell the user:

> Entering dev mode. I'll treat this as a normal code repo — CLAUDE.md note-taking rules are suspended.
>
> I will NOT auto-capture, auto-commit, or auto-push anything. I'll act as a standard coding assistant.
>
> What would you like to work on?

## Behavior in Dev Mode

For the rest of this conversation, **ignore the following CLAUDE.md sections**:
- "How to Record a Note"
- "How to Save an Image"
- "How to Save a Link"
- "Explorations"
- "Auto-Routing"
- "Commit Messages" (use conventional commits instead: `feat:`, `fix:`, `docs:`, `perf:`, etc.)
- "Rules" (the "always commit and push" rule does NOT apply)

**Instead, behave as a standard software engineering assistant:**
- Read code before modifying it
- Don't auto-commit or auto-push — only when explicitly asked
- Use conventional commit messages
- The `tasks/` directory contains project TODOs, progress, and lessons — reference and update them as needed
- The `.claude/skills/` directory contains skill definitions — you can create, edit, and test them
- `setup.sh`, `README.md`, `CLAUDE.md`, `.gitignore` are all fair game to edit

## Rules

- Dev mode lasts for the entire conversation (or until the user says to exit it)
- Don't capture any conversation content as notes
- Don't push unless asked
