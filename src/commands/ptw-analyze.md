---
description: Analyze the print folder (brochure, flyers, logos, photos) — asset inventory, visual identity, content structure, recommended web format
argument-hint: <path to the print folder>
allowed-tools:
  - Read
  - Glob
  - Bash
  - Write
  - AskUserQuestion
---
# ptw-analyze — Print folder analysis

Folder to analyze: $ARGUMENTS (if empty, ask for the path — never guess).

Use this template as the output structure:
@templates/analyse.md

If nothing was injected above (the template file is missing — typical of a global install without a project init), STOP: "templates/analyse.md not found — run `~/.claude/print-to-web/install.sh init` (or the curl installer with `init`)". Never rebuild the structure from memory: a silently absent template produces an off-spec document nobody notices.

This command does NOT ask the framing questions (that's /ptw-brief). It produces the facts that will make the questionnaire smart: what the folder contains, the real visual identity, the content volume, and an argued format recommendation.

Reminder (repo rules): talk to the user and write docs/analyse.md in the language of the print documents. Verbatim quotes stay verbatim.

## Workflow

### Step 0 — Preflight (the /ptw-doctor contract, inline)
Before touching any document, run the /ptw-doctor checks: PDF rendering, WebP encoder, JPEG/PNG conversion — **executing** each tool, not just locating it. Report everything missing or broken AT ONCE with one consolidated install command. Only PDF rendering blocks this phase; a missing WebP encoder doesn't block the analysis but WILL stop /ptw-assets five phases from now — say so now, while installing costs nothing, instead of interrupting the client mid-run.

### Step 1 — Inventory
List the folder recursively (ignore .DS_Store). Classify each file: brochure (PDF), logo (and its variants), perspective/3D visual, photo, floor plan, business card, other. Record dimensions and weight (`sips -g pixelWidth -g pixelHeight` or equivalent, read-only).

### Step 2 — Content reading
- Read the brochure page by page (Read handles PDFs; PDF > 10 pages: read in slices via `pages`). If PDF reading fails, extract the text another way (markitdown, `sips` page 1) and report the limitation.
- Look at the key images (logos, one perspective, a sample of photos) to judge their likely web usage and quality.
- Reconstruct the editorial structure: brochure sections, key messages, figures, contacts, legal notices. Figures and contacts are copied verbatim.

### Step 3 — Visual identity
Extract from the logo and the brochure: palette (approximate hex values, saying so), identifiable typefaces (+ a plausible web equivalent if the print font isn't free — marked "to confirm"), recurring shapes and graphic motifs (e.g. the branches of a logo reused as layout elements). You observe, you invent nothing.

### Step 4 — Format recommendation
Propose one page / multipage / one page + annex pages, argued from: real content volume, number of self-standing sections, likely audiences, presence of content with its own lifecycle (news, catalog). It is a recommendation — the decision is made in /ptw-brief.

### Step 5 — Write
Fill every section of the template. Content gaps (no team photo, no "about" text, incomplete contact…) go into **docs/gaps.md** — the pipeline's SINGLE gap register (create it from templates/gaps.md, one line per gap, `source: analyse`, status `open`). Never filled freestyle, never duplicated into other docs: they all point to this file. Write docs/analyse.md. If the project is a git repo, commit (`docs: analyse`).

End with: "Analysis ready in docs/analyse.md. Recommended format: <format>. Next step: /ptw-brief" (in the user's language).
