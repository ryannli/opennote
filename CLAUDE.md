# OpenNote — AI-Powered Personal Info Bank

## Config

- **Timezone**: TIMEZONE_PLACEHOLDER

## What This Repo Is

This is a **Personal Info Bank** — a simple, chronological repository for capturing anything: thoughts, notes, images, links, meetings, and more. You send content via Claude Code (mobile or desktop), and AI captures, organizes, and syncs it to GitHub.

## Workflow

The user sends content via Claude Code. Claude's job is to:

1. **Detect intent** and route to the right behavior
2. **Capture** the content into the correct file and directory
3. **Commit** with a clear message
4. **Push** to GitHub so everything stays synced

## Auto-Routing

The user should never need to type a skill name. When the user sends a message, detect their intent and apply the right behavior automatically:

| Intent signal | Route to | Examples |
|--------------|----------|----------|
| A raw thought, quote, or fragment — no action needed | **dump** behavior | "Asymmetry is the whole game", "the best frameworks feel invisible" |
| An idea with potential — something to build, try, or explore | **idea** behavior | "What if we did X", "a marketplace for unused SaaS seats" |
| A task, action item, or something to do | **todo** behavior | "finish the API docs by Friday", "remind me to call Alex" |
| Wants to reflect, review, or find patterns | **reflect** behavior | "what have I been thinking about?", "review my week" |
| Looking for a previous note or trying to recall something | **search** behavior | "what did I say about APIs?", "find that idea about marketplaces" |
| Wants to delete or discard a note | **remove** behavior | "delete that note about X", "remove the flossing reminder" |
| A URL/link | **link** capture (see How to Save a Link) | `https://example.com/article` |
| An image | **image** capture (see How to Save an Image) | *(attached image)* |
| Wants to explore/synthesize across notes | **exploration** (see Explorations) | "brainstorm ideas from my notes this week" |

**When ambiguous, default to dump** — it's better to capture fast than to over-categorize. The user can always reclassify later.

Skills can still be invoked explicitly with `/dump`, `/idea`, `/todo`, `/reflect`, `/search`, `/remove` — but the user shouldn't need to.

## Directory Structure

```
opennote/
├── CLAUDE.md          # This file — instructions for Claude
├── notes/             # All captured content, one file per topic
│   ├── 2026-03-06_product-ideas.md
│   ├── 2026-03-07_meeting-with-alex.md
│   ├── 2026-03-08_book-highlights.md
│   └── ...
└── explorations/      # Themed explorations derived from raw notes
    ├── 2026-03-10_weekly-themes.md
    ├── 2026-03-15_project-brainstorm.md
    └── ...
```

## How to Record a Note

When the user sends a piece of text, thought, information, or idea:

1. Determine the current date (YYYY-MM-DD format)
2. Determine a short, descriptive topic slug (e.g., `product-ideas`, `meeting-with-alex`, `book-highlights`)
3. Create a new note file: `notes/YYYY-MM-DD_topic-slug.md`
4. Use this format:

```markdown
---
date: YYYY-MM-DD
created: "HH:MM"
type: note
summary: 1-2 sentence summary of the note's core content, enabling quick scanning and progressive exploration.
---

# Title

<content goes here>
```

### Format rules:

- **YAML frontmatter** at the top with:
  - `date`: the date of the note
  - `created`: the time it was created (use the timezone specified in Config above). Get the current time with `TZ='<timezone>' date '+%H:%M'`.
  - `type`: one of `note` (default), `idea`, `reflection`, `learning`, `meeting`, `link`, `observation`, `todo` — classifies the content for filtering and analysis
  - `summary`: 1-2 sentence summary of the note's core content — this enables **progressive exploration** (scan summaries first, then load full content only when needed)
- **One topic per file** — if the user sends multiple unrelated items, create separate files
- **Related items can be grouped** — if several entries are about the same topic, combine them into one file with sections
- Keep the original language of the content (don't translate)
- Preserve the user's tone and wording; light formatting is okay (e.g., adding line breaks for readability)
- If the content is very short (a single sentence or phrase), still record it as-is — don't pad it
- **Distinguish sources**: For external content, note the source in the summary and/or body (e.g., `(source: Hacker News)`, `(from a conversation with Alex)`). This prevents confusing external viewpoints with the user's own opinions.
- **Don't over-capture**: Only record when the user explicitly asks. Don't automatically capture fluid thinking or casual discussion during conversations.

## How to Save an Image

When the user sends an image:

1. **Read the image** — extract and understand the text/content in it
2. Create a note file `notes/YYYY-MM-DD_topic-slug.md` with the extracted content:

```markdown
---
date: YYYY-MM-DD
created: "HH:MM"
type: observation
summary: 1-2 sentence summary of the image content.
---

# Title

<extracted text/content from the image, formatted for readability>

<any additional caption or context the user provided>
```

- Always extract the meaningful content from images into text — this makes it searchable and useful for pattern discovery later
- Keep the original language of the extracted content
- Use light formatting to improve readability but stay faithful to the source

## How to Save a Link

When the user sends a URL/link:

1. **Fetch the link** — use WebFetch to retrieve the page content and understand what it is
2. Create a note file with the link and extracted metadata:

```markdown
---
date: YYYY-MM-DD
created: "HH:MM"
type: link
summary: 1-2 sentence summary of the link content and why it was saved.
---

# Title

<user's caption or context, if any>

**Link**: <URL>
**Domain**: <what domain/field this belongs to, e.g., AI, startup, philosophy, productivity>
**Relevance**: <why this might matter to the user / how it relates to the user's interests>
**Summary**: <1-3 sentence summary of the link's content>
```

- The goal is to add enough context so that when revisiting, it's immediately clear what the link is about and why it was saved — without needing to re-open it
- Keep the original language of the user's caption; metadata fields can be in whichever language feels natural

## Explorations

The user may ask Claude to explore raw notes through a specific lens or theme, e.g.:

- "brainstorm startup ideas based on my notes from this week"
- "what patterns do you see in my thinking over the past month?"

When this happens:

1. **Progressive exploration**: First scan the frontmatter summaries of relevant `notes/` files (by date range, filename, and `type` field), then load full content only for the most relevant notes
2. Analyze and synthesize the raw content through the requested lens
3. Create a new file in `explorations/` named: `YYYY-MM-DD_topic-slug.md`
   - The date is the date the exploration was created (not the source notes' dates)
4. Use this format:

```markdown
# <Topic Title>

**Date**: YYYY-MM-DD
**Source**: notes from YYYY-MM-DD to YYYY-MM-DD
**Lens**: <the angle/perspective used>

---

<exploration content: insights, patterns, brainstorms, conclusions, etc.>
```

- These are the refined **outputs** — the value extracted from raw material
- Be thorough and thoughtful; this is where hidden patterns get surfaced
- Reference specific raw notes where relevant to maintain traceability

## Commit Messages

Format: `note: <brief summary>`, `idea: <brief summary>`, `todo: <brief summary>`, `reflect: <brief summary>`, `remove: <brief summary>`, or `explore: <brief summary>`

## Purpose

Over time, this info bank accumulates enough raw material to **discover hidden patterns** — recurring themes, evolving interests, and latent ideas. The more you capture, the better AI understands your thinking — surfacing connections and insights you might miss on your own.

## Rules

- Keep it simple. This is a capture tool, not a CMS.
- Don't over-organize. Chronological order is the primary structure, topic is the secondary structure.
- Don't translate or rewrite the user's words unless asked.
- Always commit and push after adding content.
