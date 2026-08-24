---
description: Check whether a newer version of the print-to-web plugin is available, and apply the update on confirmation
allowed-tools:
  - Read
  - Bash
  - AskUserQuestion
---
# ptw-update — Keep the plugin current

This command updates the PLUGIN (commands, rules, templates), not the project. Report in the user's language.

## Step 1 — Detect the install and its version
Find the nearest `.ptw-version`, in this order: `./.claude`, `./.codex`, `~/.claude`, `~/.codex`. Note every location that has one (a project may target both Claude and Codex — both must be updated together). None found → STOP: "print-to-web is not installed here — see https://github.com/Dupflo/print-to-web#installation".

## Step 2 — Compare with the remote
Read-only network check:

    git ls-remote https://github.com/Dupflo/print-to-web.git HEAD

- Remote unreachable → say so and stop (offline is not an error to fix).
- The installed version is a prefix of the remote SHA → "✅ Up to date (version <sha>)." and stop.
- Otherwise (different SHA, or a date-stamped version from a curl install) → an update is available.

## Step 3 — Confirm and apply
Show installed → remote versions and remind what update does: replaces the tooling tracked in `.ptw-manifest` (the user's own commands are never touched), refreshes unmodified templates only, never touches AGENTS.md. Then ask via AskUserQuestion: "Update now?" — Update / Not now.

On Update, run, from the project root:

    curl -fsSL https://raw.githubusercontent.com/Dupflo/print-to-web/main/install.sh | bash -s -- update [--target codex|all]

with `--target` derived from Step 1 (`.claude` only → default; `.codex` only → `--target codex`; both → `--target all`). For a global-only install (`~/.claude` / `~/.codex`), run the same command with `--global` from any directory.

Report the installer's output verbatim, including any "template locally modified — not overwritten" warnings, and remind that `--force` exists for those.

End with: "print-to-web updated to <version>." or the exact blocking state.
