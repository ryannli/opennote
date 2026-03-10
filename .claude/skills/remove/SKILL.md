---
name: remove
description: Find and remove a previous note that's no longer needed
user_invocable: true
---

# /remove — Remove a Note

Find and delete a note that's outdated, wrong, or no longer needed.

## Instructions

**Batch operations. Minimize tool calls.**

1. Search for matching notes in one Bash call:

   ```bash
   grep -rl "<keyword>" notes/ && echo "---" && ls -1 notes/ | grep -i "<keyword>"
   ```

   Use both content search and filename search to find candidates.

2. Show the user a short list of matches with their summaries (read frontmatter):

   ```bash
   head -6 notes/<match1>.md notes/<match2>.md
   ```

3. **Confirmation behavior depends on context:**

   - **Interactive mode** (`notei` / `claude`): Ask the user to confirm which note(s) to delete. Wait for their response.
   - **One-shot mode** (`note` / `claude -p`): If there is **exactly one match**, show its title and summary and delete it directly. If there are **multiple matches**, list them all with summaries and tell the user: "Multiple matches found. Run `notei` to pick which one to delete." Do NOT delete when ambiguous.
   - **Exact filename given** (e.g., `/remove 2026-03-10_flossing.md`): Delete it directly without searching.

4. Once confirmed (or auto-confirmed per above), delete + commit + push in one call:

   ```bash
   rm notes/<filename>.md && \
   git add -A && git commit -m "remove: <brief reason>" && git push &
   ```

## Rules

- **Never delete when ambiguous in one-shot mode** — list matches and direct user to interactive mode
- In interactive mode, always confirm before deleting
- If no matches found, say so and suggest alternative search terms
- Keep output concise — just filenames and summaries, not full content
