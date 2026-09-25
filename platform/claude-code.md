# Claude Code

Status: verified with Claude Code 2.1.109 on macOS (headless sessions with the plugin loaded from a folder).

## Connect the folder

Start the session from the Brain folder (`cd <folder> && claude`), or add it to a running session with `/add-dir <folder>`. The path is also stored in `~/.config/pola/root`, so the brain can be reached from any project.

## Connect a source

A folder of notes needs no connector: name the folder; it must be readable from the session. Connectors signed in on claude.ai can appear in Claude Code depending on how you are logged in; the assistant lists the tools it really sees and assumes nothing from the account alone. Never type a password or token into the chat.
