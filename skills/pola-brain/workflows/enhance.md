# Enhance: revise selected pages on request

`POLA` and the change-set format are described in the pola-brain skill. Read `BRAIN.md` first.

This workflow answers requests like "revise Jonas's page from the sources" or "check this project area". It works on the pages named, never on all pages at once. There is no compile step and no regeneration.

## Steps

1. Narrow down which pages are meant. One page, or the pages of one project or person. If the request is broad ("everything"), start the lint workflow instead and come back with the user's selection.
2. Read each page with `POLA read` (keep the `sha256`), then the sources it cites, then newer sources that mention the same subject (`POLA search`).
3. Decide what changes: add supported statements, mark overtaken ones with both sources, fix links, set `updated`, adjust the index line. Keep the `id`. Keep the page's `visibility`; making it visible to the network needs the owner's explicit request. Keep every sentence you cannot trace to your own earlier writing: text the user wrote by hand stays, even if it has no source. If you cannot tell where a passage comes from, keep it, or show the conflict. Do not promise to detect every manual edit. Above the line you revise; below it you only add timeline entries. A correction by the owner wins: the page shows the corrected statement, the old one stays marked as corrected with its source, and the correction becomes a new timeline entry.
4. **Small, clearly requested additions**: apply directly as one change set and report.
5. **Large rewordings, restructuring or anything that removes text**: show the change first as a diff (old lines with `-`, new lines with `+`, only the affected parts) and wait. Before a yes nothing is written. After a no nothing is written and you do not ask again in this session.
6. Apply with `replace` and the `expected_sha256` you read. `CONFLICT_STALE` means the page was edited in the meantime, for example in Obsidian: stop, read the page again, show what changed, and rebuild your proposal on top of the user's edit. Never overwrite it.
7. Only the pages in scope, the index and the log change. `POLA validate`, log entry `## [YYYY-MM-DD] enhance | <pages>`, short report.
