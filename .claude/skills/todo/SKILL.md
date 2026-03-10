---
name: todo
description: Task capture with optional scheduled follow-up reminders
user_invocable: true
---

# /todo — Task Capture

Capture a task as a note and optionally schedule a follow-up reminder.

## Instructions

**Do everything in a single Bash call.** Minimize tool calls for speed.

1. Parse the user's input for:
   - The task description
   - Priority (if mentioned — high/medium/low, default: medium)
   - Deadline (if mentioned — extract the date)
   - Reminder time (if mentioned — e.g., "in 10 minutes", "tomorrow at 9am")
2. Run **one** Bash command that creates the note, commits, pushes, and sets the reminder:

```bash
DATE=$(TZ='TIMEZONE_PLACEHOLDER' date '+%Y-%m-%d') && \
TIME=$(TZ='TIMEZONE_PLACEHOLDER' date '+%H:%M') && \
FILE="notes/${DATE}_<todo-slug>.md" && \
cat > "$FILE" <<'NOTEEOF'
---
date: <DATE>
created: "<TIME>"
type: todo
summary: <1 sentence describing the task>
priority: <high|medium|low>
deadline: <YYYY-MM-DD or omit line if none>
status: open
---

# TODO: <Task Title>

<task description in the user's words>
NOTEEOF
git add "$FILE" && git commit -m "todo: <2-4 word summary>" && git push & \
REMINDER_SECONDS=<seconds> && \
nohup bash -c "sleep $REMINDER_SECONDS && osascript <<APPLESCRIPT
display notification \"<task summary>\" with title \"📓 OpenNote\" subtitle \"Todo Reminder\" sound name \"Ping\"
APPLESCRIPT" > /dev/null 2>&1 &
```

Note: the heredoc content should use the actual values, not the placeholders. Construct the file content with the real date, time, summary, and user content.

- Parse natural language times: "in 10 minutes" = 600s, "in 1 hour" = 3600s
- For absolute times, calculate seconds from now until target time
- Tell the user the exact time the reminder will fire
- If no reminder time was mentioned, omit the `nohup` reminder line and ask the user if they want one

## Terminal mode warning

**Important**: If the user is running this via `claude -p` (one-shot terminal mode, e.g., `note "/todo ..."` via a shell alias), warn them:

> ⚠️ Reminder will only fire if this terminal window stays open. For reliable reminders, keep it open or use an interactive `claude` session.

When in doubt, include the warning.

## Rules

- Always capture the task first, then handle the reminder
- Don't force reminders — only set them up if the user wants them
- Keep the note concise — this is a task, not an essay
- If the user provides a deadline, mention it in the reminder prompt
- Use `osascript` with heredoc for notifications — do NOT use `osascript -e` (emoji breaks inline quotes)
- **Fast** — one Bash call for the whole operation, push in background
