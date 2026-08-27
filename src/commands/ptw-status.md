---
description: Print → web project state derived from the files — completed phases, next command
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---
# ptw-status — Where the project stands

Derive the state from the files — never guess. Bash is read-only here. Report in the user's language.

1. Check the existence of each pipeline doc, in order:
   - docs/analyse.md (+ the recommended format, grep the recommendation section)
   - docs/prd.md (+ frontmatter: `validated: yes|no` — an unvalidated PRD blocks the mockup)
   - docs/stories.md (+ story count)
   - docs/design-system.md
   - docs/wireframe.md (+ section count)
   - docs/assets.md (+ count the files in assets/web/)
   - docs/mockup-brief.md (+ the Figma link if present)
   - site/index.html (HTML bonus)
   - docs/reviews/*.md if any (+ their `Review passed:` verdicts — a `no` is worth a warning line)
2. Print a compact table: phase | state (✓ / — / blocked) | detail. The first missing phase is the next step; a phase that exists but whose upstream gate regressed (e.g. PRD back to `validated: no`) is marked "blocked".
3. Content gaps: read **docs/gaps.md** (the single register) and count the `open` lines — that's the list of what the client still owes. No docs/gaps.md (project started before it existed) → fall back to grepping the CONTENT GAP markers across docs/, and suggest consolidating them into docs/gaps.md.
4. Template drift: if `templates/` exists, compare each doc's modification date to its template's. A doc older than its template (or written when the template was absent — e.g. templates installed later by `install.sh init` or an update) is flagged "written on an older structure — worth realigning", one line per doc. Advisory, blocks nothing.

If docs/ doesn't exist: the project hasn't started — point to /ptw-analyze <folder> (or /ptw <folder> to chain everything).

End with the single most useful command right now, e.g.: "Next: /ptw-wireframe".
