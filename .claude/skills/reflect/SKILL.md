---
name: reflect
description: Periodic reflection that references recent notes and surfaces themes
user_invocable: true
---

# /reflect — Periodic Reflection

Create a reflection that draws on recent notes to surface themes and patterns.

## Instructions

1. **Scan recent notes in one Bash call** — get date, list files, and read frontmatter together:

   ```bash
   DATE=$(TZ='TIMEZONE_PLACEHOLDER' date '+%Y-%m-%d') && \
   TIME=$(TZ='TIMEZONE_PLACEHOLDER' date '+%H:%M') && \
   echo "Date: $DATE $TIME" && \
   ls -1 notes/ | tail -20 && \
   head -6 notes/*.md
   ```

2. Load full content of the most relevant notes (batch reads where possible)
3. If the user provided a specific reflection prompt, use it as the lens. Otherwise, reflect broadly.
4. **Write the note, commit, and push in one Bash call:**

```bash
FILE="notes/<DATE>_reflection.md" && \
cat > "$FILE" <<'NOTEEOF'
---
date: <DATE>
created: "<TIME>"
type: reflection
summary: <1-2 sentence summary of the reflection's key insight>
---

# Reflection — <Date or Period>

<the reflection — what stands out, what's changed, what's emerging>

## Themes

<3-5 recurring themes or patterns observed across recent notes>

## References

<list of note files referenced, as bullet points>
NOTEEOF
git add "$FILE" && git commit -m "reflect: <2-4 word summary>" && git push &
```

Note: the heredoc content should use the actual values, not the placeholders.

## Rules

- Ground the reflection in actual notes — don't fabricate themes
- Reference specific notes by filename so the reflection is traceable
- Keep it honest and useful, not generic or motivational
- If there are too few notes to reflect on, say so and capture what's there
- **Minimize tool calls** — batch reads where possible, write+commit+push in one call
