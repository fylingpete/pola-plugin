# Query: answer from the brain

`POLA` is described in the pola-brain skill. Read `BRAIN.md` first. A question never writes anything by itself.

## Steps

1. Run `POLA search --brain R --query "<the important words>"`. It reads the existing index and adds a targeted text search over pages and sources; it builds no new index. Use two or three different wordings when the first finds little: names, the topic, a synonym in the brain's language.
2. Read the result honestly:
   - `ok`: hits with `ref`, `via` (index or text) and a revision.
   - `no_results`: nothing matched. A short index line that does not mention something is no proof that the brain lacks it, which is why the text search ran as well.
   - `partial` (time limit) or `unavailable` (could not read): say so. This is **not** the same as "the brain has nothing on this".
   - `coverage.index_stale` lists index entries whose page is gone. Mention it; do not repair it unasked.
3. Read the pages behind the hits with `POLA read --brain R --ref <ref>`, then the sources those pages cite. Answer only from what you read.
4. Answer in the user's language with the source behind each statement, and end with the list of sources as "What the user hears" in the pola-brain skill says. Keep first hand and hearsay apart as the page does. If sources contradict each other, give both.
5. If something is missing, say exactly what is missing and which kind of source would supply it. `EVIDENCE_MISSING` on a cited source means the file is gone: say that the evidence can no longer be checked.
6. General knowledge is allowed only when you label it clearly as not coming from the brain. Never present a guess as something the brain knows. Knowing that a person could help is not their consent to be contacted; never claim such consent.
7. If the answer combines several pages into something worth keeping, offer to file it as a page. Only after a yes: type according to `BRAIN.md`, sources are the sources of the pages used, written through the capture workflow. A log entry exists only when a page was filed.
