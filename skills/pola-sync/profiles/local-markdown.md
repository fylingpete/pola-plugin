# Profile: folder of Markdown or text notes (`local-markdown`)

Status: tested with real files. Provider name: `local-markdown`.

- **Recognise.** The user names a folder. It must be readable in this session (in Cowork: selected or inside the project).
- **Preview first.** `POLA source preview --folder "<abs path>"` shows the number of note files, total size, examples and the largest files. It reads nothing into the brain. Show this to the user and let them confirm the folder, or narrow it to a subfolder. A folder with thousands of files: suggest a subfolder or a time span first.
- **First span.** Everything in the confirmed folder. Work in steps of ten and report after each step.
- **Selection.** `.md`, `.markdown`, `.txt`. Hidden files, symlinks and other file types are ignored.
- **Skip.** Empty files, templates, pure link lists, files the user excluded.
- **Source format.** `source_id` is the path relative to the folder, `revision` a fingerprint of the content: an edited note comes back as a new revision and is stored as a new source; the earlier one stays. Stored under `sources/files/<source id>/`. The external files are never changed, moved or renamed.
- **Types that result.** Depends on the note: any type of `BRAIN.md` except `archive/`; otherwise `inbox/`.
- **Questions to the user.** Only the folder, exclusions, and real ambiguities.

## Taking over an existing brain

When the folder is what the user calls their brain (an Obsidian vault, a notes folder they have kept for years), it is the starting point of the new brain. The brain lives in its own folder next to it; the notes are copied, never moved, and the folder itself is never changed.

1. **Picture first.** `POLA source analyze --folder "<abs path>"` gives the structure without any reading by you: notes per folder, sizes, notes with frontmatter, the most linked names, the time span, the number of steps of ten. It says nothing about content. Show it in five short lines.
2. **Every note is read.** There is no shortcut: whether a note is already a page, and whether it holds something from "Topics the owner keeps out", shows only in its text. Whole folders the user excluded are the one exception; they are never opened. `POLA import plan` lists the next notes; read each with `POLA source read`.
3. **Then decide per note:**
   - **It already is a page** — one person, one company, one project, one idea, one text. Take it over: you send only the classification, the tool copies the text. Excluded passages go into `omit`, word for word; they disappear from source and page alike.
   - **It is a collection** — a journal, a meeting log, a list touching several people or projects. Work it in through the ingest workflow as usual (`raw_source` with `from_local`); it leads to several pages.
   - **Nothing to keep** — empty, a template, a pure link list, or you cannot separate excluded content reliably: `POLA import reject`.
4. **Take over up to 20 notes in one call:** `POLA adopt --brain R --input -` (add `--dry-run` to preview):
   ```json
   { "intent": { "request": "<the user's words>", "scope": "take over notes from <folder>: sources, pages, index, log", "basis": "onboarding" },
     "source": "<id in sources.json>", "folder": "<abs folder>",
     "notes": [ { "path": "Kontakte/Jonas.md", "type": "person", "title": "Jonas Weber", "file": "jonas-weber",
                  "summary": "one sentence for the index", "tags": ["vertrieb"], "aliases": ["jonas@example.org"],
                  "omit": ["<excluded passage, word for word>"], "links": { "Acme GmbH": "acme" } } ] }
   ```
   `type` comes from the closed list in `BRAIN.md`; `file`, `summary`, `tags`, `aliases`, `omit`, `links`, `confidence`, `happened` are optional. For each note the tool stores the source under `sources/files/<source>/`, builds the page with frontmatter and a line naming the source, translates the note's `[[links]]` to the file names of this brain (`links` only where you know a page is called differently; pages taken over earlier follow by themselves), adds the index line and the log entry, and marks the note as done. You never retype note text.
5. **Read the answer per note.** `adopted`, `already` (done in an earlier run), or `failed` with a code. `TARGET_EXISTS`: a page of that name exists; the same name does not prove the same person. If the identity is clear, work the note in through ingest, otherwise choose another `file`. `links_without_page` lists names the note links to that have no page yet; that is normal while the folder is only partly read.
6. **Checkpoint** after each page of items as always, then report the step in the user's terms: taken over, worked in, left out (count only), what comes next.

An edited note comes back in a later run as a new revision. Its page already exists then, so it is worked in through ingest; the earlier source stays.
