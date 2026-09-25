---
name: pola-sync
description: Use when the user wants to connect, try out or fetch a source for their brain (a notes folder, Granola or other meeting transcripts, email, Notion), asks what can be imported or how much, when an earlier import was interrupted, or when the pola-onboard skill asks for the first import.
---

# Brain sync

Fetches items from **one** source, stores what is allowed as sources, and works them into pages with the ingest workflow of the pola-brain skill. The tool keeps the import state, so a run can stop anywhere and continue without gaps or duplicates.

`PLUGIN` is the folder two levels above this skill's base directory; `POLA` means `sh "PLUGIN/tools/pola"`. Commands, change sets and the page contract are described in the pola-brain skill; load it if you have not.

In Cowork, `POLA` is the tool copy on the user's device (see `platform/cowork.md` in `PLUGIN`); a notes folder has a different path in every task, so look it up under `$HOME/mnt/` and keep the path the user knows in `sources.json`.

Never ask for passwords, tokens or API keys. Sign-in always happens in the connector, by the user, outside this conversation.

## What is supported

| Profile | File | Services with a live run |
|---|---|---|
| Folder of Markdown or text notes | `profiles/local-markdown.md` | real files, Obsidian vaults |
| Meeting transcripts | `profiles/meeting-transcripts.md` | Granola (Fireflies, Circleback: same profile, no live run yet) |
| Email | `profiles/email.md` | Gmail (Outlook: same profile, no live run yet) |
| Calendar | `profiles/calendar.md` | not imported into pages: kept as a mirror for the pola-meeting-prep skill |
| Notes & documents | `profiles/notion-pages.md` | Notion pages (Google Drive: same profile, no live run yet) |

The test status is for the developer, not for the user: never tell the user that a source is "simulation-tested", "a trial" or "not verified". What the user hears is the first-run amount ("the first run takes 20 conversations; afterwards I ask whether you want more") and, once per session before the first source is read, that what you read leaves their computer and is processed on Anthropic's servers (platform file). Chat exports are not implemented: record them as `planned` and offer the pola-memory-migrate skill instead.

## How much the first run takes

Meetings: the **5 newest**. Email: **20 threads**. Notion: **10 pages** that look central, shown as a list first. A folder of notes: the confirmed folder. `POLA env` and `POLA import plan` repeat this as `first_run`. After the first run report what came in and ask **once** whether the user wants more and how far back (for example 14 days, 30 days, 90 days); name that long transcripts make large runs slow. Later runs fetch what is new since the last one.

## Say how long it takes, before you start

How long a run takes depends on the source and the amount, and guesses have been far off. Nobody waits in front of a chat. So before a run starts the user learns that it can take a while, in a place that stays in view: Cowork and the Claude app fold away text written right before a command or a connector call.

- **The run follows a choice dialog** (the source dialogs of the onboarding): the note stands in the message right before that dialog, on its own lines, rendered in the user's language with the same content:

  > ⏳ **This can take a few minutes — with a lot of data even 10 to 20 minutes.** You don't have to wait: do something else, the report will be here.

- **The user asked for the run directly** ("fetch my emails of the last two weeks", "import my Granola meetings"): first the question, as a choice dialog, with the time right under the start option:

  > **[What you will read, in a few words — for example "Your emails of the last 14 days."] Shall I start?**
  >
  > 1 · **Yes, start** — ⏳ a few minutes · with a lot of data 10 to 20 · no need to wait, the report comes here
  > 2 · **Not now**

  After "Yes, start" begin the run without another message. "Not now" is a normal answer: store nothing, change nothing.
- **Carrying on** an interrupted run, and **scheduled runs**, ask nothing.

Do not promise a number of minutes before the run. Progress notes during the run are folded away with its steps; put what you measured into the report instead ("53 conversations in 6 minutes"). Work without further chatter and end with the report.

## Steps

0. "Set up automatic sync", "keep my brain up to date by itself": follow step 8b of the pola-onboard skill and its scheduled-sync file (next to that skill). If the user asked in general to add sources or information ("connect another source", "I want to add something") and named none, ask the question under "The next thing to add" in the pola-onboard skill; people are always one of the options and lead to the pola-people skill, and what the user's AI already knows leads to the pola-memory-migrate skill.
1. Find the brain and read `BRAIN.md`, as in the pola-brain skill. `POLA status --brain R`: if a change set is pending, `POLA resume` first. Entries listed under `to_retry` (`staged`, `failed`) are part of this run.
2. Read `.brain/sources.json` with `POLA status` (field `sources`). Format:
   ```json
   { "version": 1, "sources": [ { "id": "notes", "profile": "local-markdown", "status": "connected", "folder": "/abs/path", "window_days": 90, "exclude": [] }, { "id": "gmail", "profile": "email", "status": "connected", "window_days": 40, "exclude": [], "sync": "weekly", "sync_day": "Sunday" } ] }
   ```
   `status` is `planned`, `connected` or `failed`. The file is written through `POLA apply` like any other (`create` or `replace` of `.brain/sources.json`). Cursor and page token are **not** in this file; the tool keeps them in its import state.
3. Load the profile file for the chosen source. The first time an email or notes source is connected, ask once which senders, folders or labels must never be read; "none" is a normal answer. Enter them under the preferences in `BRAIN.md` (`"schema_change": true`) or as `exclude` of the source. If its connector is not there yet, do not stop: ask which service to connect (connector rule in the pola-onboard skill), announce the sign-in, and go on once the connector answers. For local notes check that the folder is readable. Set `status: failed` only after a real failed attempt.
4. A request like "fetch my emails of the last 14 days" or "three meetings from Granola" names source and scope: after the start question ("Say how long it takes, before you start") run it. Do not show the selection and ask "shall I import these?"; the selection, what was skipped and why belong in the report afterwards. Ask only when the scope is really open, for example when fewer items match than the user asked for. "Which calendar?", "which labels?", "is this selection fine?" are not open scope: use the defaults of the profile and report them.
5. Plan the run: `POLA import plan --brain R --input -` with `{"source":"<id>","profile":"<profile>","folder":"<abs path>"}` for local notes, or `{"source","profile","provider","items":[…one fetched page…],"page_token","next_page_token"}` for connector pages. Pass only metadata fields in `items`, not bodies. The answer lists `todo` (at most 50 per run), `done`, `filtered` (dropped by the profile's fixed rules) and `deferred`. Only finished revisions are skipped; a changed revision of a known item comes back as new.
6. For every `todo` item, in order:
   - Read it (local notes: `POLA source read --folder F --path <source_id>`).
   - Apply the exclusions from `BRAIN.md` and the `exclude` list of the source **before** anything is stored. Cannot separate reliably, or the item is out of scope: `POLA import reject --brain R --input -` with `{"source","provider","source_id","revision","reason"}`, reason one of `excluded-content`, `out-of-scope`, `unreadable`, `owner-declined`. No content, no quote.
   - **A local note that already is a page** (one person, one company, one project …) is taken over with `POLA adopt`: you classify, the tool copies the text and builds the page. See "Taking over an existing brain" in `profiles/local-markdown.md`.
   - **Local notes are stored by the tool, not retyped by you:** `"raw_source": {"origin":"files/<source id>","title":"…","happened":"…","from_local":{"folder":"<abs folder>","path":"<source_id>","omit":["<excluded passage, word for word>"]}}`. Do not pass `body` or `fidelity`; the tool reads the note, takes out exactly the passages in `omit` and sets `verbatim` or `redacted` itself. An `omit` entry that does not occur word for word is refused.
   - Otherwise one change set through the ingest workflow, mode batch, with `raw_source` (`origin` = `files/<id of this source in sources.json>` for local notes, e.g. `files/notes`, otherwise that source id; `fidelity` `verbatim` or `redacted`, plus `url`, `title`, `happened`, `participants` when known) and `"import": {"source","provider","source_id","revision","updated_at"}`. Equal titles cannot collide: file names come from id and revision.
   - **Stopping early.** If the user has to leave, or a batch is large, you may store the accepted source alone: a change set with only `raw_source` and `"import": {…, "mark": "staged"}`. `POLA status` lists it under `to_retry` with its `raw_path`. When work continues — also in a new session — send the pages, index and log with `"import": {…, "mark": "applied"}` and **without** `raw_source`; cite the stored `raw_path`. The source is never stored twice.
7. **Always**, after each page of items, even when the page had a single item — a run without it is not finished: `POLA import checkpoint --brain R --input -` with `{"source","provider","items":[…the page in its order…],"page_token","next_page_token"}`. The cursor only moves across entries finished without a gap; a failed entry holds it back and is retried next run. With 53 items the first run takes 50 and the next run the remaining three.
8. Errors from a connector: sign-in expired → tell the user to sign in again in the connector, change nothing, stop. Rate limit → wait and retry at most three times, then stop; the state is kept. Offline → stop, offer to retry later. Never skip ahead.
9. `POLA validate`, then report in the user's terms and in a few lines: source, fetched, skipped, rejected (count only), pages created, pages updated, contradictions, what went to the inbox, what would be useful next. Name no file paths and no example pages to open; the user looks at their brain in the view (`POLA view`, see the onboarding skill). If a view was published earlier (`view_url` in `.brain/onboarding.json`), build it again and publish it to the same address, and say so in one sentence.
