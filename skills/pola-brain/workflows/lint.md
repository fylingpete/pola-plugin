# Lint: check the brain

`POLA` is described in the pola-brain skill. Read `BRAIN.md` first. Lint reads; it changes nothing except one log entry at the end, and only if the user asked for the check.

## Steps

1. `POLA validate --brain R`. Errors break the page contract and come first in the report. Warnings (few links, links to pages that do not exist yet) are hints, not faults.
2. `POLA status --brain R`. Name unfinished change sets and sources that are `staged` or `failed`; offer `POLA resume` or a new sync run.
3. Then what only reading shows. Go through the index and read pages selectively, not the whole brain at once:
   - statements that contradict each other across pages
   - statements a newer source has overtaken, where the page still shows only the old one
   - things mentioned on several pages that have no page of their own
   - relationships the sources support but no link shows
   - `inbox/` filling up with items of one kind (a hint for the evolve-schema workflow, not a reason to act)
   - content on a topic that stays inside (`BRAIN.md`) on a page that is visible to the network
   - possible duplicates: the `POLA validate` hints (the same email address or name on two pages) and people with similar names at the same company (`POLA resolve` with `name` and `org`). Propose a merge only as a question; after a yes it runs through `POLA merge`.
   - gaps a further source or a web search could fill
4. Suggest three questions worth asking the brain and three sources worth adding.
5. Report by severity: contract errors, contradictions, outdated statements, missing pages and links, the rest. For each finding name the page and the source.
6. "Tidy up my whole brain" ends here with a **limited proposal**: the five to ten changes that matter most, each as a concrete page change. Apply only what the user picks, through the enhance workflow. There is no rebuild of all pages and no regeneration of pages.
7. Append one log entry: `## [YYYY-MM-DD] lint | <n> findings` with the counts.
