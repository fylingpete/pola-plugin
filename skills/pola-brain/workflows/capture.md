# Capture: what the user tells you

`POLA`, the change-set format and the page contract are described in the pola-brain skill. Read `BRAIN.md` first.

## Request or mere telling?

- **Explicit request** — "remember that …", "note down …", in any language: this authorizes storing the accepted words and the page changes they support. Do it; do not ask "shall I save this?" again.
- **Mere telling** — the user mentions something in passing, or asks a question: nothing is stored. If it is worth keeping, offer once, in one sentence, to save it, and name what you would store. Wait for the answer. Before a yes there is no source, no page and no log line. A question alone never creates a page.

Ask back only for a real ambiguity: which of two people with that name, a statement that contradicts a page, or a change that would rewrite or remove a lot. For those, show the concrete difference first.

## Steps

1. Pin down request and scope in one sentence for yourself: whose page, which statement. That sentence goes into `intent.scope`; the user's words go into `intent.request`.
2. Apply the topics the owner keeps out (`BRAIN.md`) to the user's words; by default there are none. Statements on those topics are not written down at all, not even paraphrased, and you do not list them back. If something was left out, the source gets `fidelity: redacted`; otherwise `verbatim`. Content on a topic that stays inside goes only to a private page.
3. The accepted words become a source under `sources/pola/`: `raw_source` with `provider: "pola"`, `origin: "pola"`, `source_id: "YYYY-MM-DD-<short-title>"`, `revision: "1"`, `fidelity`, `happened`, the words as `body`, plus `origin_label: "pola-plugin"`, `session: "<today>"` and `about: ["[[page]]", "[[page]]"]` for the pages concerned.
4. Find the pages concerned: `POLA resolve` for people and companies (`exact` is clear, `similar` only a candidate), otherwise `POLA search` and the index. Same name does not mean same person: update only when the identity is clear.
5. Build the page changes with the source path from `POLA raw-path` in `sources` and in the text. New pages get an id from `POLA new-id`. Small additions to an existing page keep everything that is there, including text the user wrote by hand. New pages follow the template of their type in `BRAIN.md`. A dated event the user reports becomes one timeline entry on the page concerned.
6. Source, pages, index and log are **one** change set. No confirmation per file.
7. `POLA apply`, then `POLA validate`.
8. Report in two or three sentences what you stored and where, and what the brain already knew about the people and companies involved.

Storing locally never publishes, sends or shares anything.
