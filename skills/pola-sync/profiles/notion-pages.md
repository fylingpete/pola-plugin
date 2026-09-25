# Profile: Notion pages (`notion-pages`)

Live run: Notion pages (2026-09-20). Google Drive documents use the same rules. Notion meeting notes are a different thing: the dedicated tool for them needs a Notion Business plan; without it, meeting notes are ordinary pages.

- **Recognise.** Connector tools that search the workspace and fetch a page.
- **First run.** 10 pages that look central. Judge centrality from what the workspace shows: top-level pages and hubs with many sub-pages or links, pages edited recently and often, pages whose titles name the user's company, products, projects or people. Show the 10 as a numbered list (title, where it sits, last edited) and let the user swap entries before anything is read. This one question is part of the profile, because "central" is a proposal.
- **Skip.** Empty pages, templates, archives, pure link lists, databases as a whole (take single entries only when the user names them).
- **Source format.** One source per page with `title`, `url`, `happened` (last edited); `source_id` is the page id, `revision` the last-edited time.
- **Types that result.** Projects, concepts, companies, people, writing, org, media; otherwise `inbox/`.
- **Questions to the user.** The list of 10, and which teamspaces or pages to leave out.
