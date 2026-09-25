---
name: pola-people
description: Use when the user wants to add people to their brain, go through who matters to them, tell more about someone who is already in the brain, or when the pola-onboard or pola-sync skill hands over to capturing people.
---

# People

People are the most important thing in a brain: almost every question worth asking it ("who could help with …", "what connects …") runs through them. This skill gets them in by conversation. It needs no connector and no access to anything; the user talks, you write it down. It can be started at any time, as often as the user likes.

`PLUGIN` is the folder two levels above this skill's base directory; `POLA` means `sh "PLUGIN/tools/pola"`. Commands, change sets, the page contract, exclusions and the rule against guessed identities are in the pola-brain skill; load it before the first write. Talk to the user as described under "How you talk to the user" in the pola-onboard skill: short, choice dialogs with keywords, no technical names. Texts in quote blocks are the exact content of what the user reads, written in English; render them in the user's language, informal, same length. `[square brackets]` are filled from the brain.

## Start

Find the brain and read `BRAIN.md` as in the pola-brain skill. Then, as a choice dialog:

> **People are the most important thing in your brain.** What would you like to do?
>
> 1 · **Add new people** — area by area · or from your apps
> 2 · **Tell more about people who are already in** — fill thin pages

If the brain has no person pages besides the user's own, skip the question and start with new people.

## Add new people

### Where to look

As a choice dialog. Fill the examples from the brain: areas from the user's own page, projects and companies from their pages.

> **Where do we look for people?**
>
> 1 · **Areas of my life** — [work] · [yoga] · family · friends · hobbies
> 2 · **My projects and companies** — who belongs to [project]? · who at [company]?
> 3 · **My apps** — WhatsApp · phone contacts · email · LinkedIn

- **Areas.** Derive them from what the brain knows about the user, then offer the ones that are missing as a multiple choice: family, friends, hobbies, former jobs, clubs and neighbourhood. People forget whole areas until they are named.
- **Projects and companies.** One page at a time: "Who belongs to [project]?"
- **Apps** are a memory aid, not a data source. You cannot read them and you do not ask for access. Ask the user to open one and look: the last twenty chats in WhatsApp, the favourites in the phone's contacts, the people they wrote to most in their mail, recent messages and connections on LinkedIn. They say the names, or drop a screenshot of the list in here; from a screenshot you take names only. If an email source is already connected to this brain, you may offer to list the people the user wrote to most in the last 90 days, names only, and only after a yes.

### One area at a time

1. Names first:

   > Who comes to mind for [yoga]? Just the names.

2. Then a few words on each, in groups of at most five, the names shown as a list:

   > Tell me one or two sentences about each: how you know each other, what experience they have and what they are really good at, what you can learn from them — and who else knows them.

   Whatever the user says is enough. Do not interrogate, and do not ask for what they left out.
3. **Show what you understood before you write.** Spoken names and roles get mixed up. A short list, one line per person — name · role · area — then as a choice dialog:

   > **Did I get that right?**
   >
   > 1 · **Yes, write it down**
   > 2 · **Something is wrong**

4. Write one change set per group through the capture workflow of the pola-brain skill: the user's words for this group, word for word, as **one** source (`basis: "onboarding"` during onboarding, otherwise `"explicit-request"`; the user chose to add people, that is the request), then the person pages, index and log.
   - Before creating a person, search the index and `aliases`. The same name is only a candidate: if a page exists and the identity is clear, add to it; if it is not clear, ask.
   - The sections of a person page and their names come from `BRAIN.md`. Write what the user said, attributed to them; first hand unless they say otherwise. Experience, skills and what the user can learn from them go into the section for experience and skills; people both know go into the section for who else knows them, each as a link when they have a page, and those people become candidates for the next round of names. Do not ask what the person is looking for; if the user says it anyway, it goes into that section. A section with nothing yet keeps one line saying so: it reminds the user to fill it in later. Dated events the user names — when they met, a job change — also become entries in the page's timeline.
   - The area goes into `tags`. `relationship` is set only when the user said how close they are; it is never guessed.
   - Link every person to the pages the user connected them with: the user's own page, a project, a company, another person ("I know her through Lisa Marie").
   - The exclusions of `BRAIN.md` apply to every sentence.
5. Follow the threads the answers open, one question at a time: "Who else do you know through [Lisa Marie]?", "Who does [Ladina] work with?"
6. After the area, two lines: how many people are in, how many pages link to each other now. Then, as a choice dialog: go on with [next area] · enough for today.

Progress lives in `.brain/people.json`, written through `POLA apply` (`create`, later `replace`), so the next session continues where this one stopped:

```json
{ "version": 1, "areas": [ { "name": "Yoga", "status": "done", "people": 6 }, { "name": "Family", "status": "pending", "people": 0 } ], "updated": "2026-09-21" }
```

## Tell more about people who are already in

`POLA view --brain R --data` lists every page with the number of its sources and links. Offer three people whose pages say little, as a choice dialog; anyone else through the free-text field. For the chosen person ask the same things (how you know each other, their experience and what they are really good at, what the user can learn from them, who else knows them), and what changed since the brain last heard of them. The lines on the page that say "nothing yet" show where to ask. Store through the capture workflow: the words as a source, then the page. Keep everything that is on the page, including what the user wrote by hand.

## End

Say what was added, in numbers. If a view was published earlier (`view_url` in `.brain/onboarding.json`), build it again with `POLA view --brain R` and publish it to the same address, and say so; otherwise the user sees the old view and thinks nothing happened. Close with:

> You can add people at any time — just say "add people".

If this skill was started from the onboarding, go back to it and continue there.
