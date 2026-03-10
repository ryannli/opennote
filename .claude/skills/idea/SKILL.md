---
name: idea
description: Structured idea capture with potential and next steps
user_invocable: true
---

# /idea — Structured Idea Capture

Capture an idea with lightweight structure to make it actionable later.

## Instructions

**Do everything in a single Bash call.** Minimize tool calls for speed.

1. Determine a short topic slug, summary, potential, and next steps from the idea
2. Run **one** Bash command that does it all:

```bash
DATE=$(TZ='TIMEZONE_PLACEHOLDER' date '+%Y-%m-%d') && \
TIME=$(TZ='TIMEZONE_PLACEHOLDER' date '+%H:%M') && \
FILE="notes/${DATE}_<topic-slug>.md" && \
cat > "$FILE" <<'NOTEEOF'
---
date: <DATE>
created: "<TIME>"
type: idea
summary: <1-2 sentence summary>
---

# <Idea Title>

<the idea, in the user's words — lightly formatted for readability>

## Potential

- <why this idea could be valuable>
- <what it enables or where it could lead>

## Next Steps

- <concrete small action 1>
- <concrete small action 2>
NOTEEOF
git add "$FILE" && git commit -m "idea: <2-4 word summary>" && git push &
```

Note: the heredoc content should use the actual values, not the placeholders. Construct the file content with the real date, time, summary, and user content.

## Rules

- Keep the user's original framing — don't over-polish
- **Potential** should be genuine observations, not hype
- **Next Steps** should be small and concrete — things that could be done in a day
- If the user provides context about why the idea matters, weave it in naturally
- **Fast** — one Bash call for the whole operation, push in background
