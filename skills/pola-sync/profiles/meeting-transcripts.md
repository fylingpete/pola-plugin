# Profile: meeting transcripts (`meeting-transcripts`)

Live run: Granola (2026-09-20). Fireflies and Circleback use the same rules. The first run takes the 5 newest meetings; then ask once whether the user wants more.

- **Recognise.** Connector tools whose names mention the provider and list or fetch meetings, notes or transcripts. If none is visible, follow the platform guide and do not claim a connection.
- **First run.** The 5 newest meetings. Then ask whether the user wants more and how far back; the plan's upper bound is 90 days. Transcripts are long: for a meeting of more than an hour prefer the provider's notes plus the transcript passages they point to, and say so.
- **Selection.** Prefer the transcript over the summary when both exist.
- **Skip (fixed rules in the tool).** Under five minutes. No second participant.
- **Topics kept out.** Remove passages on the topics the owner keeps out before storing and mark the stored source `fidelity: redacted`.
- **Source format.** One source per meeting with `title`, `happened`, `participants`, `url`.
- **Types that result.** `meetings`, `people`, `companies`, `projects`, and `deals` or `hiring` when the conversation is about one. Every participant with a page gets an entry on it.
- **No question before the run.** All folders the connector shows, minus what `BRAIN.md` excludes. The one question of this profile comes after the first three: whether the user wants more and how far back.
