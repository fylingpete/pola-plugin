# Scheduled morning prep: one task

A scheduled task is an unattended Cowork run. This one prepares the user every weekday morning for the day's meetings and keeps the prep in one file that every run overwrites. You create it with the host's tool for scheduled tasks; the user only confirms days and time. Everything else in this file is the content of that task.

## Before creating

1. The calendar is connected and the mirror exists (steps 1 and 2 of the pola-meeting-prep skill).
2. Show the user in one line what you are about to create, and wait for a yes:

   > **I'll set up:** your meeting prep · Mon–Fri at [7:30] · reads your calendar and your brain · keeps only the day's prep in your Brain folder.

3. Settings of the task: name `Brain: meeting prep (Mon–Fri [time])`; weekdays at the confirmed time; folder = the Brain folder; permissions "automatically approve"; "require this computer" on; **model Opus**. Instructions = the text below, filled in, in the user's language.
4. After creating: record `"prep": "daily"` and `"prep_time"` on the calendar source in `.brain/sources.json` (`POLA apply`, `replace`). Do not claim the task ran; it has not yet.
5. Then the folder permission, below. Never skip it.

## The folder permission

Like every scheduled task, this one may only touch the Brain folder once the user has allowed it for every run; without that, no prep is ever made. Give the user the message and the choice dialog of the section "The folder permission (the user has to do this)" in the pola-onboard skill's file on the scheduled sync, with this task's name. In the onboarding it comes once for every task of step 8b, this one included.

## The task text (template)

Fill every `[bracket]`. Keep the structure; add nothing that is not in the brain's rules. Render in the user's language.

> You prepare [OWNER] for today's meetings from [OWNER]'s Pola brain. This is an unattended, scheduled run: ask no questions. Speak [LANGUAGE].
>
> 1. Load the skills pola:pola-meeting-prep and pola:pola-brain and follow them. The platform is Cowork: read platform/cowork.md in the plugin folder and work by the section "Working on the user's device". The brain is on [OWNER]'s computer in the connected folder [BRAIN PATH]; in the device shell it is mounted under $HOME/mnt/[FOLDER NAME] (check with `ls "$HOME/mnt"`). The tool lies there under .pola-tools/pola.cjs; compare its sha256 hash with PLUGIN/tools/pola.cjs in the container and copy the file there with the host's tool for committing files if it differs or is missing. From then on POLA means `node "$HOME/mnt/[FOLDER NAME]/.pola-tools/pola.cjs"` in the device shell; define it as a shell function at the start of every device-shell call (`POLA() { node "$HOME/mnt/[FOLDER NAME]/.pola-tools/pola.cjs" "$@"; }`), never as a plain variable, because the folder name may contain spaces.
> 2. Check `POLA status --brain "$HOME/mnt/[FOLDER NAME]"` first: an open change set is resumed with `POLA resume`. Then refresh the calendar mirror from today to 3 days ahead with the [SERVICE] connector (step 1 of the skill). If the connector is unavailable or its sign-in has expired, prepare from the mirror as it is and say at the top of the prep that [OWNER] has to sign in again in the [SERVICE] connector.
> 3. `POLA calendar check --brain "$HOME/mnt/[FOLDER NAME]" --json '{"days":1}'` lists today's meetings. Prepare each of them by step 4 of the skill: only what is in the brain, every statement with its source; for a meeting the brain knows nothing about, the short version that says so. The prep begins with one line that names the day, for example **Meeting prep · Wednesday, 24 September**.
> 4. Keep the prep: `POLA prep store --brain "$HOME/mnt/[FOLDER NAME]" --input -` with `{"text":"…"}`, the prep exactly as your last message shows it. The tool overwrites the prep of the previous run; only the latest is kept. Nothing else is written: no page, no source, no log entry, no deletion.
> 5. The prep is your last message. Without meetings today, the prep is the line with the day and one sentence that says so; store it all the same, so that no older prep stays behind.
