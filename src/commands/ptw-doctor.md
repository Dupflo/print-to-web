---
description: One-pass environment check — PDF rendering, WebP encoder, Figma-ready formats. Reports EVERYTHING missing at once, with install commands, before the pipeline starts.
allowed-tools:
  - Bash
  - Read
---
# ptw-doctor — Check the tools before the pipeline needs them

A real-world run stopped three times for environment reasons, all detectable up front. This command exists so that never happens again: one pass, every tool tested, every missing piece reported TOGETHER with its install command — before the first document is written.

Cardinal rule: **execute each tool, never just locate it.** `which cwebp` can return a valid path while the binary fails to load (missing dylib). A tool that is found but doesn't run counts as broken, and broken is reported louder than absent.

## Checks (run them all — never stop at the first failure)

1. **PDF rendering** (needed by /ptw-analyze):
   - `pdftoppm -v` → exit 0 = OK.
   - Fallback on macOS: `sips --getProperty pixelWidth` on any PDF renders page 1 — test with a real PDF from the project if one is at hand, otherwise note "sips present, untested on a PDF".
   - Neither works → report: `brew install poppler`.
2. **WebP encoder** (needed by /ptw-assets — the #1 hard stop in the field):
   - `cwebp -version` → exit 0 = OK. A path found but a non-zero exit (e.g. `dyld: library not loaded`) = **broken install** → report: `brew reinstall webp` (and name the missing library from the error output).
   - Else `magick -version` (ImageMagick with WebP delegate: `magick -list format | grep -i webp`).
   - Else `sips`: actually try an encode on a tiny test image in the scratchpad — `sips -s format webp <test>.png --out <test>.webp` — success = OK.
   - Nothing encodes → report: `brew install webp`.
3. **JPEG/PNG conversion** (needed by the Figma path of /ptw-mockup — Figma's canvas does not render WebP): `sips` (always on macOS) or `magick`. Note which will be used.
4. **Optional helpers** — presence only, never blocking: `git` (per-phase commits), `codex` (stronger /ptw-review), Figma MCP tools (only checkable from the session, note "verify when picking the mockup tool").

## Report

One compact table: tool | status (✅ works / 🔴 broken / ⚪ absent) | consequence (which phase stops) | fix. Then, if anything is missing or broken, ONE consolidated install line the user can copy-paste (e.g. `brew install poppler webp`). Offer to run it, but never install anything without an explicit go.

End with either "Environment ready — nothing will interrupt the pipeline." or "N tools to fix before starting — one command: `<consolidated install>`" (in the user's language).
