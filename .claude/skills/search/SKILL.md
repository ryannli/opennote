---
name: search
description: Search through notes by keyword, theme, or time range
user_invocable: true
---

# /search — Search Notes

Search through captured notes to find a half-remembered idea, a specific topic, or notes from a time period.

## Instructions

**Batch operations. Minimize tool calls.**

1. Determine what the user is looking for — could be:
   - A keyword or phrase
   - A theme or topic
   - A time range ("last week", "in February")
   - A note type ("my todos", "ideas")

2. Search in one Bash call, combining multiple strategies:

   ```bash
   echo "=== Filename matches ===" && \
   ls -1 notes/ | grep -i "<keyword>" ; \
   echo "=== Content matches ===" && \
   grep -rl "<keyword>" notes/ ; \
   echo "=== Type matches ===" && \
   grep -l "type: <type>" notes/
   ```

   For time-range queries, filter by filename prefix (e.g., `ls notes/2026-03-*`).

3. Read the frontmatter of matches to show summaries:

   ```bash
   head -7 notes/<match1>.md notes/<match2>.md notes/<match3>.md
   ```

4. Present results as a concise list:
   - Filename, date, type, and summary for each match
   - If many matches, show the top 5-10 most relevant

5. If the user wants to see the full content of a specific note, read it for them.

## Rules

- **No file creation** — this is read-only, don't create notes or explorations
- Cast a wide net — search both filenames and content
- For vague queries ("that thing about APIs"), try multiple keywords
- Show enough context (summary) so the user can identify the right note without reading the full thing
- If nothing matches, suggest related terms or broaden the search
