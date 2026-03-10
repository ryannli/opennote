---
name: dump
description: Ultra-fast raw capture — minimal formatting, no embellishment
user_invocable: true
---

# /dump — Raw Capture

Capture the user's content as fast as possible with minimal processing.

## Instructions

**Do everything in a single Bash call.** Minimize tool calls for speed.

1. Determine a short topic slug and summary from the content
2. Run **one** Bash command that does it all:

```bash
DATE=$(TZ='TIMEZONE_PLACEHOLDER' date '+%Y-%m-%d') && \
TIME=$(TZ='TIMEZONE_PLACEHOLDER' date '+%H:%M') && \
FILE="notes/${DATE}_<topic-slug>.md" && \
cat > "$FILE" <<'NOTEEOF'
---
date: <DATE>
created: "<TIME>"
type: note
summary: <one sentence max>
---

# <Short Title>

<user's content exactly as provided>
NOTEEOF
git add "$FILE" && git commit -m "note: <2-4 word summary>" && git push &
```

Note: the heredoc content should use the actual values, not the placeholders. Construct the file content with the real date, time, summary, and user content.

## Rules

- **No embellishment** — do not add context, analysis, or formatting beyond basic readability
- **No questions** — do not ask the user anything, just capture
- **Minimal summary** — one sentence max, keep it short
- **Preserve exact wording** — do not rephrase or restructure
- **Fast** — one Bash call for the whole operation, push in background
- **Minimal output** — just confirm the note was captured, nothing more
