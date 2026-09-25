# Evolve schema: add or change a page type

`POLA` and the change-set format are described in the pola-brain skill. Read `BRAIN.md` and `brain.yaml` first.

The standard types work from the first minute. A change is optional and never blocks an import.

## When

- The user asks for it in their own words ("I want a place for tools").
- Or you make **one concrete proposal** because the material clearly needs it, and the user confirms it.

Never on a schedule, never after a fixed number of imports, never as a required question. Never create a folder without this workflow, even if the user says it would be quicker: say where the item goes now (`inbox/`) and offer this workflow.

## Proposal

Name the new folder and type, what belongs there and what does not, the file-name pattern, its visibility (`private` or `network`, with a reason), and the evidence: log entries and `inbox/` pages that would move. Wait for a yes.

## After approval, one change set

Set `"schema_change": true` in `intent` and `"basis": "confirmed-proposal"`. All of this together:

1. `BRAIN.md`: the new row in the type table (`replace` with the hash from `POLA hash`).
2. `brain.yaml`: the `folder: type` entry under `pages.types` (`wiki.types` in brains created before 2026-09-21), and `folder: private` or `folder: network` under `visibility.types` when the brain has a `visibility` section.
3. The folder: `create` `pages/<folder>/.gitkeep` with empty content.
4. `pages/index.md`: the new heading.
5. Pages that move out of `inbox/`: one `move` each (`path`, `to`, the text with the new `type`, `expected_sha256`). The `id` stays, and links keep working because they go by file name. Do not use `create` plus `delete` for this.
6. Log entry `## [YYYY-MM-DD] evolve-schema | <type>` with the reason and the moved pages.

`BRAIN.md` table, `brain.yaml` and the folders must match; the tool rejects a change set that leaves them inconsistent. Finish with `POLA validate` and tell the user in two sentences what is new and that the list is closed again.

Removing a type works the same way: move its pages to `archive/` or `inbox/` first, then remove row, entries and heading. Changing the level of an existing type from `private` to `network` is not yours to propose: only on the owner's explicit request, with `"visibility_change": true` in addition.
