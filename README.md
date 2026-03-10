<div align="center">

# OpenNote

**Capture fragments today. Make better decisions tomorrow.**

*Your thoughts, compounded.*

[Quick Start](#quick-start) · [Usage](#usage) · [How It Works](#how-it-works) · [Examples](#examples) · [Why Plain Files?](#why-plain-files)

</div>

---

<table>
<tr>
<td width="250">
<img src="demo-mobile.gif" alt="OpenNote mobile demo" width="250">
</td>
<td>

You're on the bus and a thought hits you. You open Claude on your phone and say:

```
Asymmetry is the whole game when the future is uncertain.
```

**Hit send. That's it.** Claude handles the rest — organizes it into a markdown file, commits, and pushes to your Git repo. Timestamped, categorized, searchable, and yours forever.

</td>
</tr>
</table>

## Highlights

- **Capture from anywhere** — Phone, desktop, or CLI. Drop a thought, a screenshot, a URL, or meeting notes. No app to install.
- **AI organizes for you** — Just dump content in. AI structures it into clean markdown files, auto-categorized by topic and date.
- **You own your data** — Plain markdown + Git. No vendor lock-in. No cloud database. `grep` works.

---

<table><tr><td>

### The real power: AI that evolves you

Most note apps are just storage. OpenNote is different — every note you capture becomes part of AI's understanding of *you*.

Over weeks and months, your info bank accumulates fragments: a product idea on Monday, a meeting note on Wednesday, a quote that resonated on Friday, a frustration you vented about on Sunday. Individually, they're just notes. But AI can read across all of them — and **surface the hidden threads you'd never notice yourself.**

Ask it to brainstorm, and it doesn't start from zero. It draws on everything you've ever captured — your interests, your patterns of thinking, your recurring frustrations, your half-formed ideas — and weaves them into insights that feel like they came from your subconscious. *Because in a way, they did.*

</td></tr></table>

---

## Quick Start

> Expects [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [GitHub CLI (`gh`)](https://cli.github.com/) installed.

```bash
git clone https://github.com/ryannli/opennote.git my-notes
cd my-notes
./setup.sh
```

Setup will automatically create a **private** GitHub repo for your notes and switch the remote. Your notes never touch a public repo. The original template is kept as `upstream` so you can pull future updates with `git pull upstream main`.

## Usage

### Basic capture

Just tell Claude what you want to remember:

```bash
claude "Asymmetry is the whole game when the future is uncertain."
```

Or open Claude on your phone and just start talking.

### Skills

OpenNote ships with built-in skills for different types of capture:

**You don't need to remember commands.** Just send your content naturally — AI detects your intent and routes it automatically:

```bash
note "the best frameworks feel invisible"           # → captured as a note
note "what if we sold unused SaaS seats"             # → captured as an idea with next steps
note "finish the API docs by Friday"                 # → captured as a todo
note "what did I say about marketplaces?"            # → searches your notes
```

Skills can also be invoked explicitly if you prefer:

| Skill | What it does |
|-------|-------------|
| `/dump` | Ultra-fast raw capture — no formatting, no questions asked |
| `/idea` | Structured idea with **Potential** and **Next Steps** sections |
| `/todo` | Task capture with optional scheduled reminders |
| `/reflect` | Periodic reflection that surfaces themes from recent notes |
| `/search` | Find a half-remembered idea or note by keyword, theme, or date |
| `/remove` | Delete a note that's outdated or no longer needed |

### Shell aliases

Add these to your `.bashrc` or `.zshrc`:

```bash
alias note='cd ~/opennote && claude -p'    # one-shot: capture, search, quick actions
alias notei='cd ~/opennote && claude'      # interactive: multi-turn conversations
```

**`note`** is one-shot — send a thought, get it captured, done. Perfect for quick capture, search, and todos.

**`notei`** opens an interactive session — use it for multi-turn workflows like `/remove` (which needs confirmation when there are multiple matches), `/reflect`, or exploring your notes in conversation.

```bash
# One-shot (note)
note "always bet on simplicity"
note "remind me to call Alex in 30 minutes"
note "/search that API thing from last week"

# Interactive (notei)
notei                          # opens a session
> delete that note about flossing
> what patterns do you see in my notes this week?
> /reflect
```

### Zero permission prompts

OpenNote includes repo-level permissions (`.claude/settings.json`) so standard capture operations — reading, writing notes, git commit/push — run without any approval prompts. Just send and go.

## How It Works

```
You (phone or desktop)          ← the only thing you do
  → Claude Code                 ← everything below is automatic
    → structured markdown file
      → Git commit & push
        → GitHub (synced)
```

No manual filing, no tagging, no folder management.

## Examples

| You send | AI creates |
|----------|------------|
| `"Asymmetry is the whole game when the future is uncertain."` | `notes/2026-03-09_asymmetry-and-uncertainty.md` — timestamped note with your thought, auto-categorized |
| *sends a photo of a whiteboard* | `notes/2026-03-09_whiteboard-notes.md` — extracts all text from the image into a searchable note |
| `https://example.com/interesting-article` | `notes/2026-03-09_interesting-article.md` — fetches, summarizes, and saves with context |
| `"what patterns do you see in my notes from the past week?"` | `explorations/2026-03-09_weekly-patterns.md` — finds recurring themes across your notes |


## Directory Structure

```
opennote/
├── CLAUDE.md          # AI instructions — customize how notes are organized
├── notes/             # One file per topic, organized by date
│   ├── 2026-03-06_product-ideas.md
│   ├── 2026-03-07_thoughts-after-meeting-alex.md
│   └── ...
└── explorations/      # You + AI thinking together through your notes
    └── 2026-03-10_weekly-themes.md
```

- **`notes/`** — Where everything lands. Each note has YAML frontmatter (date, time, summary) for quick scanning.
- **`explorations/`** — You and AI think together — pick a lens, and explore your notes to find patterns and ideas you wouldn't see alone.
- **`CLAUDE.md`** — The brain of the system. Edit this to change how AI captures and organizes your content.

## Why Plain Files?

Plain files aren't just a technical choice — they're what makes the "evolve" part possible. AI can read your full history of thinking, across any time range, any topic. That's what lets it connect a frustration from January to an idea from March to a conversation from last week — and show you something you never noticed.

| | OpenNote | Typical note apps |
|---|---|---|
| **Format** | Plain markdown | Proprietary database |
| **AI access** | Full — AI reads everything, connects anything | Limited to what the app exposes |
| **History** | Full Git history | Limited or none |
| **Search** | `grep`, GitHub, or ask AI | Built-in only |
| **Portability** | Works with any editor | Locked to one app |
| **Privacy** | Your repo, your rules | Their servers |

## Customization

OpenNote is configured through `CLAUDE.md` — the instruction file that tells Claude how to organize your notes. Edit it to match your workflow. It's just a markdown file.

## License

[MIT](LICENSE)
