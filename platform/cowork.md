# Cowork

Status: measured on 2026-09-20 with desktop app 2.2553.1 (five spike runs, see `docs/spike/` in the repository). Cowork tasks run in the cloud; there is no local mode. The selector "Auto" below the message box only sets approvals (Manually approve / Automatically approve / Skip all approvals).

## Three machines

| Where | What is there | What it is for |
|---|---|---|
| Remote container (where you start) | the plugin, this file, `PLUGIN/tools/pola.cjs` | reading the skills; **never** for writing a brain: `POLA` answers `WRITE_GATE_CLOSED` here |
| The user's device, a small Linux VM reached through the device shell | the selected folder, mounted at `$HOME/mnt/<folder name>`; `node` 22; no plugin files | **all brain work happens here** |
| The user's computer | the real folder | what the user sees in Finder |

The container is discarded after the task, the session-start hook does not fire, and `~/.config` is useless. Everything that must last lives in the brain folder, except where that folder lives: that goes into your memory, because it is needed before the folder is connected (pola-onboard, "Creating the folder"). The container may hold a one-time snapshot of the folder; it is not synced, so never work on it and never carry files back from it.

Cowork tells the user that files the assistant uses leave the device and are processed on Anthropic's servers. Say this once, plainly, before the first source is read.

## Working on the user's device (do this once per task, before the first `POLA` call)

Do all of this silently. The user never hears "write gate", "container", "device route", "mount" or "hash"; at most one plain sentence in their language that you are setting up access to their Brain folder. Never mention `.pola-tools` or the helper file; the user does not need to know it exists.

1. **Find the folder.** In the device shell: `ls "$HOME/mnt"`. `M` is the mount of the folder the user selected. The path changes with every task; never store it.
2. **Put the tool next to the folder.** In the container: `sha256sum "PLUGIN/tools/pola.cjs"`. In the device shell: `sha256sum "$M/.pola-tools/pola.cjs"`. If the file is missing or the hash differs, copy `PLUGIN/tools/pola.cjs` to `<selected folder>/.pola-tools/pola.cjs` with the host's tool for committing files to the device, and compare again. Say nothing about it to the user. Copy nothing else, install nothing.
3. **From now on `POLA` means** `node "$M/.pola-tools/pola.cjs"` **in the device shell.** Folder names often contain spaces ("Brain 2"), so never put the command into a plain variable (`POLA="node $M/.pola-tools/pola.cjs"; $POLA …` breaks at the space). Define a function at the start of every device-shell call instead, and quote the path once inside it:

   ```bash
   POLA() { node "$HOME/mnt/<folder name>/.pola-tools/pola.cjs" "$@"; }
   POLA status --brain "$HOME/mnt/<folder name>"
   ```

   Everything in the pola-brain skill applies unchanged: `POLA find --cwd "<brain folder>"`, `POLA status`, `POLA search`, `POLA read`, `POLA plan`, `POLA apply --input - <<'POLA_JSON' … POLA_JSON`, `POLA validate`. A call through the bridge takes seconds while the tool needs milliseconds: put several commands into one device-shell call. `find` looks at the folder it is given and never above or below it: give it the brain folder itself, that is `$M` when the user selected it or you connected it from your memory, or the new subfolder right after `POLA init`.
4. **No delete permission for everyday work.** Measured: without it the folder allows creating, overwriting and renaming (also over an existing file) and refuses only deleting. The tool is built for exactly that: it replaces files by renaming, its lock is a token that only changes its name, and pages are moved with the `move` operation. So capture, import, revise and rename run without any extra dialog; do **not** ask for delete permission up front. Only a change set that really deletes a page (`"op": "delete"`, which you use only when the user asked for a deletion) comes back as `FS_CAPABILITY_MISSING` with `missing: ["unlink"]`. Then, and only then, ask the host for permission to delete files in the selected folder and say why in one sentence ("you asked me to delete the page …"). The user sees "Allow Claude to permanently delete files in this folder on your computer?" with **Deny** and **Allow**; it holds for the rest of the task. `POLA doctor --brain "<brain>"` shows `writing_possible` and `deleting_possible` if you need to check.
5. **Never** write brain files with the bridge's file tools, with your own file tools, or by editing a copy in the container. Only `POLA` checks paths, the old state of files and the page contract, and only `POLA` can resume an interrupted change.

Skip `POLA config set-root` in Cowork; your memory holds where the brain lives. A notes folder that serves as a source must be selected in the task too; it appears under `$HOME/mnt/` like the brain folder. Keep the path the user knows in `.brain/sources.json` and look up the mount path in every task.

## Connect the folder

Below the message box click the **folder icon** (labelled "Add folder" or "Project or folder", depending on the app version) and choose the Brain folder or the project made from it. Describe it to the user by the icon and its place first, the label second. Cowork asks twice: "Allow Claude to change files in “<folder>”?" (Cancel / Always allow / Allow) and the macOS dialog "Allow this Cowork session to access this folder?" with the box "Don't ask again for this folder on this device" (Cancel / Allow). Whether a folder can be added to a running task has not been checked: when in doubt, start a new task.

When the brain is not reachable in this task and your memory holds where it lives, connect that folder yourself: request access to exactly that path with the host's tool for folder access. Measured on 2026-09-24: `device_request_folder_access` takes the path on the Mac and a short reason; the user sees one dialog, or none when Cowork already remembers a folder that contains it; the folder then appears under `$HOME/mnt/` like a selected one. An entry written with `memory_write` in one task was read in the next.

A new brain is created in the selected folder itself when that folder is empty (the `.pola-tools` folder does not count), otherwise in a new subfolder of it.

When the user already has a brain (a vault, a notes folder), two folders are selected for the task: the existing one, which is only read, and a new empty folder for the brain next to it. Never create the brain inside the existing folder; the tool refuses to take notes from a folder that contains the brain.

## Connect a source

Customize → Connectors, choose the service and sign in there. Then the assistant checks with one read call. Never type a password or token into the chat.
