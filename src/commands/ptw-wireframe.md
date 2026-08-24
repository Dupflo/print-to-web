---
description: Homemade markdown/ASCII wireframe — desktop sections + mobile notes, mapped to the real print content
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---
# ptw-wireframe — The site's skeleton, with real content

Use this template as the output structure:
@templates/wireframe.md

Fail-closed: docs/prd.md must exist (it locks the format and the sections). Missing → STOP: "No PRD — run /ptw-brief first." docs/design-system.md is recommended but not blocking: without it, the wireframe stays purely structural (no visual indication).

The wireframe is a structure contract, not a drawing: section order, information hierarchy inside each section, and above all the mapping to real content. Lorem ipsum is forbidden — every text zone cites its source content (brochure, page/section) or carries the `CONTENT GAP` marker inherited from the PRD (translated into the user's language, e.g. `TROU DE CONTENU` in French — keep it consistent across all docs).

## Workflow
1. Read docs/prd.md (format, kept sections, CTA, priorities) and docs/stories.md if present (one story per section = the section's reason to exist, put it as a comment).
2. For each section, produce:
   - An ASCII desktop diagram (blocks, rough proportions, CTA position).
   - The content mapping: each block → real text (quoted or summarized with its reference) + likely asset (file name from the print folder).
   - Mobile notes: what stacks, what disappears, what transforms (e.g. table → cards).
3. Secondary content (from the PRD's "Secondary content" table): each item appears twice — its trigger inside the host section's diagram (button, link, "+" on a card…), and its own overlay block after the section (popup/accordion/tab content), with the same real-content mapping as any block. Secondary content is part of the wireframe, not a footnote.
4. Section order = a conversion path: the PRD's primary CTA must be reachable without deep scrolling and repeated at the end of the page.
5. Flag open structural decisions (e.g. floor plans as a gallery or as tabs?) via AskUserQuestion if they change the mockup — otherwise decide and record it.
6. Write docs/wireframe.md (in the user's language). If the project is a git repo, commit (`docs: wireframe`).

End with: "Wireframe ready in docs/wireframe.md (<n> sections). Next step: /ptw-assets" (in the user's language).
