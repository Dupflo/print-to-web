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

This command does NOT ask the framing questions (that's /ptw-brief). It produces the facts that will make the questionnaire smart: what the folder contains, the real visual identity, the content volume, and an argued format recommendation.

Reminder (repo rules): talk to the user and write docs/analyse.md in the language of the print documents. Verbatim quotes stay verbatim.

## Workflow

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
Fill every section of the template. Content gaps (no team photo, no "about" text, incomplete contact…) go into "Gaps & open questions" — never filled freestyle. Write docs/analyse.md. If the project is a git repo, commit (`docs: analyse`).

End with: "Analysis ready in docs/analyse.md. Recommended format: <format>. Next step: /ptw-brief" (in the user's language).
