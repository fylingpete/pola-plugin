---
name: pola-onboard
description: Use when the user wants to set up a brain, asks how to get started with Pola, or when a session notice reports an unfinished onboarding.
---

# Brain onboarding

Guides a user without prior knowledge from nothing to a brain they can see, question and extend: a folder, their own page, a first source, a view of the brain, two example questions that show what it can do, a second source, a wrap-up. Both ways in — a new brain, or "I already have a brain" — run through the same steps.

`PLUGIN` is the folder two levels above this skill's base directory; `POLA` means `sh "PLUGIN/tools/pola"`. Commands, change sets and the page contract are described in the pola-brain skill; load it before the first write.

## How you talk to the user

The user is new to all of this. They do not know what a vault, Markdown, frontmatter or a schema is, and they do not need to.

- **Short.** Two sentences per message at most, then the question. No explanations nobody asked for.
- **Click, don't type.** Every question with a fixed set of answers goes through the host's choice dialog. Under each option stand keywords separated by `·`, not sentences.
- **One question at a time.**
- **No technical names.** Never say `BRAIN.md`, `brain.yaml`, `.pola-tools`, `sources/`, `pages/`, "schema", "frontmatter", "simulation-tested" or a command name to the user. Say "your brain", "your pages", "your sources", "the rules of your brain".
- **Fixed wording.** Texts in a quote block below are the exact content of what the user reads. They are written in English; render them in the user's language the way a native speaker would say them, informal (German: "du"), with the same length, order and emphasis. Add nothing, explain nothing, drop nothing. `[square brackets]` are filled from the user's own brain. Names of menus and buttons in the app (**Schedule**, **Allow**, "Add folder") stay exactly as the app shows them, in English; never translate them.
- Announce a permission dialog one sentence before it appears, in plain words: what the host is about to ask and why. Example: "Claude will now ask whether it may run a command. That is the tool I write your brain with; it only works inside your Brain folder."

## Ground rules

- Ask for consent when something new is touched: a new data source, a new write scope, anything external. Steps the user already approved continue without asking again.
- Every step leaves something usable behind. No minimum number of pages, sources or questions.
- Never ask for passwords or tokens.
- **Every source is offered, connected or not.** Do not check which connectors exist before asking a source question. When the user picks a source that has no connector yet, ask which service to connect, as a choice dialog, then announce the sign-in and hand over to the connector (sign-in happens in the connector, never in the chat). The services: email → Gmail · Outlook / Microsoft 365; calendar → Google Calendar · Outlook; notes & documents → Notion · Google Drive · an Obsidian folder; meeting notes → Granola · Fireflies · Circleback. Example:

  > **For email I need a connection. Which one should I connect to?**
  >
  > 1 · **Gmail**
  > 2 · **Outlook / Microsoft 365**

  Then: "I'm connecting to Gmail now. Cowork will ask you to sign in — that happens at Google, not here in the chat." If the service is not available on this host, say so in one sentence and offer the next option.
- In Cowork (`POLA env` reports `host.write_gate: "closed"`) first follow "Working on the user's device" in `platform/cowork.md`; the brain is created by the tool copy on the user's device. There, where the brain lives goes into your memory instead of `POLA config set-root` ("Creating the folder").
- If `POLA env` fails with `RUNTIME_UNAVAILABLE`, you have no shell, or the device route in Cowork is not possible (for example in the plain Claude app), the brain cannot be created in this session. Say only this, then stop; do not list what would be created, do not explain the tool, and do not build the folder with other tools:

  > I can't set up your brain here: it's a folder on your computer, and I can only write it in Claude Cowork or Claude Code. Open one of them and say "set up a new brain for me" — it takes about 20 minutes.

Progress lives in `.brain/onboarding.json`. `POLA init` creates it with `folder` done and the surface filled in; every later change is a `replace` through `POLA apply` (hash from `POLA hash`). Keep exactly this shape; the session hook looks for `"completed": true`.

```json
{
  "version": 2,
  "platform": "cowork",
  "started": "2026-09-21",
  "start": "new",
  "phases": {
    "folder": "done",
    "about-you": "done",
    "source-1": "pending",
    "import-1": "pending",
    "view": "pending",
    "example-questions": "pending",
    "source-2": "pending",
    "import-2": "pending",
    "wrap-up": "pending"
  },
  "view_url": null,
  "completed": false
}
```

## Step 0: start

`POLA find`. In Cowork with no Brain folder connected, look in your memory first: when it names the folder where the user's brain lives, connect that folder as in step 0 of the pola-brain skill and run `POLA find` there. Only without such an entry, or when that folder holds no brain, does a new brain begin. A brain with unfinished onboarding: continue at the first step that is not `done` and say so in one sentence. "Carry on" or "continue", in any language, is the request: do not ask whether you should. Check `POLA status` first: a pending change set is resumed, and sources listed under `to_retry` are worked in now (pola-sync skill, "Stopping early"). A finished onboarding: say so and offer the next thing to add instead (step 7). Determine the surface (Cowork or Claude Code) from the conversation; if unsure, ask. Read `platform/cowork.md` or `platform/claude-code.md` in `PLUGIN`.

When nothing exists yet, open with this, three short sections with their headings in bold:

> **What your brain is**
> Your brain is a folder of text files on your computer that belongs only to you. In it we collect everything you know, for example about people, projects and companies. It forgets nothing and answers only with what you have given it.
>
> **How it gets smart**
> Connect it to your tools such as email, calendar, Notion, cloud storage or meeting transcripts, so everything relevant is in it. With an automatic sync it always stays current. And it learns as you talk to it. The longer you use it, the more it can help you.
>
> **What happens now**
> Setting it up takes about 20 minutes. I read only what you share with me and write only into this one folder.

## Step 1: folder

**The first question**, as a choice dialog with exactly these two options:

> **How do we start?**
>
> 1 · **Create a new brain** — empty brain · we fill it together
> 2 · **I already have a brain** — we take it as the starting point · analyse it · build on it

Record the answer as `"start": "new"` or `"start": "existing"`; it goes into `POLA init` (below). Do not mention notes, Obsidian or later releases here.

### 1 · A new brain

Ask where it should live, as a choice dialog. The user creates nothing by hand:

> **Where should your brain live?**
>
> 1 · **Documents / Brain** (recommended) — I create the folder for you
> 2 · **Somewhere else** — you tell me where

Then request access yourself and create the folder (announce the dialog first, see above). The folder must be new or empty; if `Documents/Brain` exists and is not empty, suggest `Documents/Brain 2` or ask. To create it, the session may get access to the parent folder for this one session; you still read and write nothing outside the Brain folder, and from the next session on only the Brain folder is selected (wrap-up).

### 2 · "I already have a brain"

An Obsidian vault, a folder of notes, whatever the user calls their brain. Whether it already has the structure of a brain is not the user's question. It becomes the starting point: a brain with the standard structure is created next to it, and its notes are copied over and brought into that structure. Nothing in the existing folder is ever changed, moved or deleted.

1. Ask for the folder:

   > Where is your existing brain? Tell me the folder — or just drop a screenshot of your Finder window in here that shows it including the full path.

   If the screenshot shows the name but not the place, give the tip in one sentence (in Finder: View → Show Path Bar) or ask only for the place ("Is it in Documents?"). Have the folder selected for this session (platform file, "Connect the folder"). It is only ever read.
2. `POLA source analyze --folder "<abs path>"`. It needs no reading by you and takes seconds. Show the user a picture of **their** folder in five short lines, from the numbers only: how many notes and in which folders, how many already carry properties, the names linked most often, from when to when, and in how many steps of ten it will be read. Say nothing about what the notes contain and do not estimate how many "are already pages": that is only known once they are read.
3. One sentence on how it goes on:

   > I create your brain next to it and bring your notes into its structure step by step. Nothing in your folder is changed.
   >
   > ⏳ **Reading your notes can take a few minutes — with a lot of data even 10 to 20 minutes.** You don't have to wait: do something else, the report will be here.

   Ask whether a whole folder should stay out. Excluded folders are never opened; record them as `exclude` of the source.
4. Create the brain in a **new, empty folder next to** the existing one, never inside it: suggest the same parent folder with the name `Brain`. From here the steps run as for a new brain. The existing folder is the first source: record it in `.brain/sources.json` (`profile: "local-markdown"`, the `folder`, the `exclude` list) with `status: connected`, because the analysis was a real successful read.

### Creating the folder (both ways)

Create it with `POLA init --input -`:

```json
{ "target": "/absolute/path/Brain", "owner_name": "Lena Hartmann", "language": "German", "date": "2026-09-21", "start": "new" }
```

Name and language are needed here, so ask for them first (step 2 has the wording). `TARGET_NOT_EMPTY` means: choose another folder; never clear one, and never turn the user's existing folder into the brain. The tool writes `onboarding.json` with `folder: done` in the same step. Then `POLA config set-root --brain "<path>"` so other sessions find the brain; if that fails, carry on, it is a convenience. In Cowork, write this sentence into your memory instead (the host's memory tool), in the user's language and with the folder's path on the Mac, never the `$HOME/mnt/…` path: "My brain — also called Second Brain or Pola brain — lives on my Mac in the folder <path on the Mac>." Replace an earlier entry about where the brain lives instead of adding a second one. Without a memory tool, carry on. Go through "Connect the folder" in the platform file, let the user confirm, and verify with `POLA find` that `brain.yaml` is readable from this session.

After the folder exists, tell the user where it is in one sentence (Finder path; nothing about its inner folders yet, that comes in step 5).

## Step 2: about you

Ask, one after another:

1. Your name.
2. The language of the brain, as a choice dialog: the language the user is writing in first, English second, anything else through free text. `POLA init` sets the section names of the page templates and the timeline heading for German or English; for another language propose all of them and change `BRAIN.md` and `brain.yaml` together with `"schema_change": true`.
3. What the user does and what matters to them. Do not ask first: look at what you already know. If this host gives you a memory of earlier conversations with this user (a memory tool, a search over earlier chats, memory files), make a short profile from it with this prompt, as if the user had sent it to you:

   ```text
   What I do and what I like: make a short profile of me from your memories. Use only things
   I said myself, nothing you inferred or made up. Only my work, my projects and what matters to
   me; nothing about my private life. At most seven points, one per line, under these headings in
   this order: "Who I am", "What I'm working on", "What I bring" (my experience, what I'm really
   good at, what I help others with), "What matters to me". Number the points straight through
   and leave out a heading without points. If you are not sure I said it, leave it out.
   ```

   First write the result as a chat message of its own, in full, before you open the choice dialog: the user must see every point they are asked to confirm. This message may be longer than two sentences. Never put the points only into the dialog, an option's description or a preview, and never leave them out:

   > I had a look at what I remember about you. This is what I found:
   >
   > **Who you are**
   > 1. [statement]
   > 2. [statement]
   >
   > **What you're working on**
   > 3. [statement]
   >
   > **What you bring**
   > 4. [statement]
   >
   > **What matters to you**
   > 5. [statement]

   A heading without points is left out. The numbers run on across the headings, so that the user can say "point 4 is wrong".

   Only then, as a choice dialog:

   > **Is this right? Shall I put it into your brain?**
   >
   > 1 · **Yes, take it over**
   > 2 · **I want to change something** — write it in the chat

   With option 2, apply what the user writes, write the corrected list with its headings again as a chat message and ask again; the corrected wording is theirs. If you have no memory of this user, or it says nothing about their work, ask instead:

   > What do you do? Tell me in two or three sentences, the way you would tell someone you have just met: what you are working on, where you come from, what matters to you.

Store an approved profile as an approved memory (step 5 of the pola-memory-migrate skill): one change set with `basis: "onboarding"`, a `raw_source` with `provider` and `origin` `"ai-memory"`, `fidelity: "verbatim"`, `origin_label: "assistant memory, approved by the owner"` and exactly the approved lines as `body`, the assistant's name and today's date in its first line; then the user's own page under `people/`, every point with this source, in the section of its heading (names from `BRAIN.md`): "Who you are" in the section on who they are, "What you're working on" in what they are working on, "What you bring" in experience and skills, "What matters to you" in hobby horses. Store a self-description the user typed through the capture workflow of the pola-brain skill (the user's answer to your question is the request; `basis: "onboarding"`): accepted words to the sources folder with the right fidelity, then the user's own page under `people/`.

Then the page types, with exactly this and nothing about files:

> Your brain sorts everything into fixed areas: people, companies, meetings, deals, hiring, projects, your organisation, texts, media, concepts, ideas, household, personal. Whatever fits nowhere goes to the inbox — nothing gets lost. If you miss an area later, just say so and we add it.

Then the topics, as a choice dialog:

> **Are there topics that should not go into your brain?** For example: finances · health · relationships
>
> 1 · **No, everything may go in**
> 2 · **Yes** — choose topics · a topic of my own

With option 2, let the user pick (several are possible) and ask for each chosen topic, as a choice dialog:

> **[topic]:**
>
> 1 · **Don't store it at all**
> 2 · **Store it, but never share it**

Enter the first kind under "Topics the owner keeps out" and the second under "Topics that stay inside" in `BRAIN.md`, replacing "none", in one change set with `"schema_change": true`. Suggest no other topics and add none of your own. Do **not** ask about senders, folders or labels here: that question belongs to the moment an email, calendar or notes source is connected (pola-sync skill).

## Step 3: first source

- `"start": "existing"`: the user's folder is the first source. Do not ask.
- `"start": "new"`: this is where the folder starts to fill. Ask as a choice dialog in exactly this order; the lines above the question are the message right before the dialog, so the user reads them before choosing:

  > **Now we start filling your brain.** The first step is one source; more come later. What I read leaves your computer and is processed on Anthropic's servers.
  >
  > ⏳ **Reading a source can take a few minutes — with a lot of data even 10 to 20 minutes.** You don't have to wait: do something else, the report will be here.
  >
  > **What do we start with?**
  >
  > 1 · **Text files you already have** — on your computer or in your cloud storage
  > 2 · **Email** — 20 conversations
  > 3 · **Meeting notes** — the 5 newest meetings · Granola · Fireflies · Circleback
  > 4 · **Notes & documents** — 10 pages · Notion · Google Drive · an Obsidian folder

  With option 3 or 4 ask which service in a second dialog when it is not clear. Past conversations, the people who matter and the calendar for meeting prep come in the second round (step 7), not here: a calendar alone fills no pages.

Say nothing about test status ("simulation", "trial", "not verified"): that is developer knowledge. The first-run amounts, the note on Anthropic's servers and the note about time are in the dialog above; do not repeat them later between tool steps, where nobody sees them. Record every chosen source in `.brain/sources.json`; `status: connected` only after a real, successful trial read (`POLA source preview` or `POLA source analyze` for a folder; for a connector a read of the three newest items, showing titles only). Record nothing the user did not choose.

If the user wants no source now, that is fine: say that the brain then grows from what they tell it, skip step 4, and go on.

## Step 4: first import

The user already read the note about time (step 3, or step 1 for an existing brain). Start the run without another message, then run the pola-sync skill for this one source. With `"start": "existing"` it follows "Taking over an existing brain" in the local-markdown profile: every note is read, notes that already are a page are taken over by the tool, the others are worked in. After the first step of ten, tell the user what that step gave (taken over, worked in, left out) and, from the time it really took, how long the rest will take; let them decide whether to go on now or next time. The state is kept. An interrupted import continues where it stopped.

## Step 5: the folder and the view

The user has not seen their brain yet. Show it twice: as the folder it is, and as a graph.

1. **The folder.** `POLA tree --brain R` prints the folder picture: where it lies, the page folders with their counts and file names, the sources folder closed, nothing that starts with a dot. Print `result.text` **verbatim** in a code block; do not rebuild, shorten or reorder it. Above it, one line:

   > Your brain is a folder on your computer. Here is what is in it now — it grows with every source and every conversation.

2. **The view.** `POLA view --brain R`. The tool builds one self-contained page from the real files: every page and source is a node, every `[[link]]` in a page is an edge, exactly as written; a bar at the top switches between **Graph**, **Overview** of all pages, and the **Info** of the selected dot. It writes `brain-view.html` into the Brain folder and prints its path. You never write or edit this file yourself; its content is the brain, not your summary of it.
3. If the host has a tool for publishing a page (an artifact), publish that file unchanged, with a two-word title like "Lena's Brain". If the file is not reachable from where that tool runs, copy it there with the host's file tools; never retype or regenerate it. Store the address as `view_url` in `onboarding.json`. The page is private to the user: call it their view, never say it was published, and never share its link or suggest sharing it.
4. Tell the user, in these words:

   > Here is your brain. Every dot is a page, every line is a link between two pages — click around. This view is private on claude.ai; the same view also lies in your Brain folder as a file you can open any time.

Without a publishing tool, point to the file in the folder instead. If the brain is still empty (no source, only the user's own page), show it all the same; it fills in step 8.

## Step 6: two example questions

Follow `example-questions.md`: first a question that shows how the brain connects things, then, by itself, one that shows where the brain still has gaps.

## Step 7: the next thing to add

This question comes in the onboarding **and every time** the user later asks to add sources or information to their brain. As a choice dialog; all sources are offered, connected or not (see the connector rule above):

> **What do we fill your brain with next?**
>
> 1 · **Past conversations with AI assistants** — Claude · ChatGPT · only what you said yourself · you approve every line
> 2 · **People who matter to me** — I ask area by area · you tell me briefly · I write it down
> 3 · **Calendar for meeting prep** — I prepare you for every meeting · from everything in your brain that matters for it
> 4 · **Something else** — email · notes & documents · meeting notes · text files

With option 4 ask in a second dialog which one comes first; the message right before that dialog is the ⏳ note from step 3, and each option names its first-run amount. "Later" comes through the free-text field. Recommend people, in these words:

> People are the most important thing in your brain. You can add more at any time.

- **Past conversations:** run the pola-memory-migrate skill.
- **People:** run the pola-people skill.
- **A connector source:** the pola-sync skill, with its first-run amounts and its one-sentence honesty note.
- **Calendar for meeting prep:** the pola-meeting-prep skill, section "From the onboarding": connect the calendar, fill the mirror, run the check once and say its result. Then, as a choice dialog:

  > **Shall we add another source, so your brain knows more about these people?**
  >
  > 1 · **People who matter to me** — I ask area by area · you tell me briefly
  > 2 · **Meeting notes** — Granola · Fireflies · Circleback
  > 3 · **Something else** — past conversations with AI assistants · email · notes & documents · text files
  > 4 · **No, go on**

  Run what the user picks, as above. Do not run the check again; the onboarding goes on with step 8.
- **Later:** fine. The onboarding goes on to the wrap-up; nothing blocks it.

## Step 8: second import, and the view again

Run what the user chose. When it is done, publish `brain-view.html` again to the **same** address (`view_url`; the tool has already rebuilt the file), so the view the user already has open shows the new pages. Say so in one sentence, with what was added in numbers. No folder picture here; that was step 5.

## Step 8b: automatic sync

Right after the second import, as a choice dialog:

> **Should your brain keep itself up to date?**
> It can fetch new items from your sources on its own, every day or every week. That runs inside Claude, writes only into your Brain folder, and nothing leaves it.
>
> 1 · **Yes, set it up** — choose sources and how often
> 2 · **Not now** — you can do it any time later with "set up automatic sync"

With yes, the sources, as a multiple choice: **Which sources should keep themselves up to date?** — **Email · Notes & documents · Meeting notes**. Text files are not offered. For every chosen source without a connector, the connector rule applies first. Then how often, one answer for all chosen sources, as a choice dialog:

> **How often should your brain fetch what is new?**
>
> 1 · **Daily at 23:00**
> 2 · **Weekly on Sunday at 23:00**
> 3 · **Another time** — write it in the chat

This answer is the confirmation; ask nothing more before creating. All tasks run at the same time: each works on its own and none waits for another, so never spread them over different times. Then follow `scheduled-sync.md`: one scheduled task per source, created by you with the host's tool for scheduled tasks. This step also runs on its own whenever the user later asks for automatic sync.

If the calendar was connected for meeting prep in step 7, offer the morning prep next, with the dialog of step 5 of the pola-meeting-prep skill, and set it up by that skill's scheduled-prep file; whatever the check found earlier, run it no second time. Without a second import, skip the question about the sync and ask only this one.

Every scheduled task, the morning prep included, runs only after the user has allowed it the Brain folder. When the last task of this step is created, give the message and the dialog of "The folder permission" in `scheduled-sync.md`, once, naming every task created in this step. Never skip it.

## Step 9: wrap-up

Short. No numbers by area, no list of sources. First a normal message with the three ways as a numbered list, then the question as a choice dialog; the question is the only thing in the dialog.

> **Your brain is set up.** The first, essential step is done. From here on it is about using it and building it out — only then does it really pay off.
>
> Three ways in everyday life:
> 1. **Ask it** — "What do I know about …?"
> 2. **Tell it something** — "Remember that …"
> 3. **Build it out** — "add a source", "add people"

Then the dialog:

> **Do you want to add anything else now?**
>
> 1 · **Yes, another source**
> 2 · **No, that's enough for today**

Option 1 goes back to step 7, and after that import to the sync offer of step 8b for the new source; then this wrap-up again. Option 2 closes with how to find the brain next time, from `platform/folder-hint.txt` in `PLUGIN` for this surface. In Cowork, when your memory holds where the brain lives:

> **For your next session in Cowork:** just ask about your brain. I remember that it lives in **[folder name]** and ask you for access.

In Cowork without that entry:

> **For your next session in Cowork:** below the message box, click the folder icon ("Add folder") and choose your folder **[folder name]**. Claude then finds your brain by itself.

Set `completed: true`.
