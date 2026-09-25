---
name: pola-meeting-prep
description: Use when the user wants to be prepared for a meeting or for the day, asks which meetings are coming up, asks for a meeting prep or a briefing on the people they will meet, wants to connect or import their calendar, wants a daily morning prep or asks what this morning's prep said, or when the pola-onboard skill hands over "calendar for meeting prep".
---

# Meeting prep

Before a meeting the user learns what their brain knows about the people in it and about the last time: who they are, what is open, what was decided. Only what the brain holds, every statement with its source. The calendar itself never becomes pages: the tool keeps a mirror of it, and this skill reads the mirror and the pages. It changes no page.

`PLUGIN` is the folder two levels above this skill's base directory; `POLA` means `sh "PLUGIN/tools/pola"`. Commands and the page contract are in the pola-brain skill. Talk to the user as described under "How you talk to the user" in the pola-onboard skill: short, choice dialogs with keywords, no technical names. Texts in quote blocks are the exact content of what the user reads, written in English; render them in the user's language, informal, same length. `[square brackets]` are filled in.

## 1. Refresh the calendar mirror

1. The calendar needs a connector (Google Calendar, Outlook); without one, the connector rule of the pola-onboard skill applies. Take the user's own and shared work calendars, not holiday, birthday or week-number calendars.
2. `POLA calendar check --brain R` tells you when the mirror was last refreshed (`refreshed`; `null` means there is none yet). Without a mirror fetch from 90 days back to 14 days ahead, in pieces of 30 days if the connector limits its answers; otherwise from today to 3 days ahead. Every day is fetched while it still lies ahead, so the past fills in by itself.
3. Pass the events on with only these fields — `id`, `summary`, `start`, `end`, `status`, `recurringEventId`, `location`, `hangoutLink`, and `attendees` with `email`, `displayName`, `responseStatus`, `self`, `organizer`, `resource` — together with the span you asked for:

   `POLA calendar store --brain R --input -` with `{"from":"YYYY-MM-DD","to":"YYYY-MM-DD","events":[…]}`

   The tool replaces that span, keeps the rest, drops what is older than 90 days, and skips rooms, declined, all-day, cancelled and solo entries. Never write calendar entries as pages or sources; the tool refuses it.
4. If the connector is not available, go on with the mirror as it is and say in one sentence when it was last refreshed.

## 2. The check

`POLA calendar check --brain R --json '{"days":3}'` lists the meetings of today and the next two days. For each: the people without the user; whether the brain knows them — a person page with at least one statement from a source other than the calendar —; the last shared appointment; the series and whether its last meeting has notes; and whether the meeting can be prepared: someone in it is known, or the last meeting of the series has notes.

Write this as the message right before the dialog of step 3:

> I looked at your next 3 days: [N] meetings. For [n] of them your brain knows enough for a good prep.[ It knows nothing yet about [names, at most five]. The quickest way to change that: tell me about them, or let me read your meeting transcripts.]
>
> 1. [day, time] · [title] · [good / thin]
> 2. …

No meetings: say so in one sentence and stop.

## 3. Which meeting

As a choice dialog, up to three of the next meetings, the ones that can be prepared first:

> **Which meeting shall I prepare you for?**
>
> 1 · **[title]** — [day, time] · [n] people
> 2 · **[title]** — [day, time] · [n] people
> 3 · **[title]** — [day, time] · [n] people
> 4 · **All of today's**

## 4. The prep

Read for the chosen meeting, with `POLA read` and `POLA search`:
- each person's page: summary, role and organisation, what they are working on, what they want, open threads, the newest timeline entries;
- the last meeting of the series or with these people, if it has a page: decisions and action items;
- what the meeting is about: `POLA search` with the names and topics in its title — a project, a company, a deal — and the pages it finds;
- pages linked to them that changed since then: projects, deals, companies.

Then write the prep as the message that ends your turn:

> **[Title] · [day, time][ · weekly, meeting 11]**
> **Last time ([date], [source]):** [decisions] · [what stayed open]
> **[Project, company or deal]:** [where it stands] · [what is open]
> **[Name]** ([role, organisation]): [one or two things to know] · [open point] · last meeting [date]
> **Follow up:** [what is owed, by whom]
> **Your brain doesn't know:** [what is missing]

- **Only what is in the brain.** Every statement comes from a page or source of this brain and names it; below the prep follows the list of sources as "What the user hears" in the pola-brain skill says. No web search, no general knowledge, no guess about a person, nothing from the invitation beyond title, time and names.
- **Invited is not present.** Say "last shared appointment", never "you last met", unless a meeting page says so.
- **Thin is said plainly.** When the brain knows nothing about the people, the prep says exactly that and gives only what the calendar shows:

  > **[Title] · [day, time]**
  > Your brain knows nothing yet about [names]. Your last shared appointment was on [date] ([title]); whether it took place is not recorded. That's all I can tell you here.

- People without a page, or with a page from the calendar only, go under "Your brain doesn't know". At the end offer in one sentence to add them (pola-people skill); create nothing without a yes.
- The prep changes no page and no source. Only the scheduled morning prep keeps its text: `POLA prep store` overwrites one file every morning, so only the latest prep is kept.

## 5. The morning prep

Offer it once after the first prep, when the check found at least one meeting that can be prepared and no morning prep is set up (`prep` on the calendar source in `.brain/sources.json`). As a choice dialog:

> **Shall I prepare you every morning for the day's meetings?**
>
> 1 · **Yes, set it up** — Mon–Fri · 7:30 · you can change the time
> 2 · **Not now**

With yes follow `scheduled-prep.md`. Record the answer on the calendar source in `.brain/sources.json` through `POLA apply` — `"prep": "daily"` with `"prep_time"`, or `"prep": "declined"` with `"prep_asked"` (the date; do not ask again within 30 days). A calendar without a sources entry gets one: `{"id":"calendar","profile":"calendar","status":"connected"}`.

When the user later asks what the morning prep said ("what was in this morning's prep about Jonas?"), read it first with `POLA prep show --brain R` and answer from it and the pages it names. `present: false` means there is none yet. When `for_today` is false, say in one sentence which day it is from.

## 6. From the onboarding

The pola-onboard skill hands over "calendar for meeting prep" in its step 7. Then do only steps 1 and 2: connect the calendar, fill the mirror, run the check, and write its result without the numbered list and without a dialog:

> I looked at your next 3 days: [N] meetings. For [n] of them your brain already knows enough for a good prep.[ It knows nothing yet about [names, at most five].]

Then go back to the onboarding. It asks about further sources and offers the morning prep in its step 8b; the check is not run again there.
