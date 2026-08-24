# print-to-web — Repo rules

## Absolute rule
No mockup and no visual generation outside the pipeline. Every print → web project goes through it, in order:

Analyze → Brief (PRD) → Stories → Design System → Wireframe → Assets → Mockup → (bonus: HTML)

No mockup is generated before the PRD is validated (`docs/prd.md` → frontmatter `validated: yes`) and the design system exists. No visual identity is ever invented: it is extracted from the print documents and the provided inspirations.

## Language
Instructions are in English; the user is not. Speak to the user and write the content of every `docs/` file in the language of the print documents (or the user's language if they differ — ask once if ambiguous). When filling a template for a non-English project, translate its section headings into the project language. Verbatim quotes from the print stay verbatim.

## Pipeline (commands)
- `/ptw-analyze <folder>`   analyze the print folder: asset inventory, visual identity, content structure, recommended web format
- `/ptw-brief`              one-pass framing questionnaire → PRD: goal, validated format, perimeter, features, constraints
- `/ptw-stories`            lightweight visitor stories — never overkill
- `/ptw-design-system`      markdown design system: tokens extracted from print + inspiration analysis + design prompts
- `/ptw-wireframe`          homemade markdown/ASCII wireframe, mapped to real content
- `/ptw-assets`             image optimization: resize + WebP with no visible degradation, originals untouched
- `/ptw-mockup`             mockup — Figma via MCP (default) or Claude Design, from the mockup brief
- `/ptw-html`               bonus: navigable static HTML/CSS prototype

Utilities:
- `/ptw`         orchestrator: runs the whole pipeline with human checkpoints
- `/ptw-status`  project state derived from the files, next command
- `/ptw-help`    pipeline map (cheat sheet)
- `/ptw-update`  check for a newer plugin version, apply it on confirmation

## Gates (mechanical, fail-closed)
- `/ptw-brief` refuses to run without `docs/analyse.md` — the questionnaire must be informed by the analysis.
- `/ptw-design-system` refuses to run without `docs/analyse.md` AND without a visual source (print identity or inspirations folder). Inventing a default identity is absolutely forbidden.
- `/ptw-wireframe` refuses to run without `docs/prd.md`.
- `/ptw-mockup` refuses to run if `docs/prd.md` does not contain `validated: yes` in its frontmatter, or if `docs/design-system.md` or `docs/wireframe.md` are missing. No file, no marker → no mockup. No exceptions.
- The `validated: yes` marker is set only by an explicit human validation (AskUserQuestion checkpoint in /ptw-brief or the orchestrator), never by the mere existence of the file.

## Content
- Three exposure levels, decided in the PRD — never a binary keep/drop: **primary** (in the page flow), **secondary** (kept, available on demand: popup/modal, accordion, tab, annex page, download), **graveyard** (dropped). Content the client wants to keep without cluttering the page goes secondary, not to the graveyard. Secondary content travels through the whole pipeline: trigger + overlay in the wireframe, its own frame in the mockup.
- Every piece of text in the mockup comes from the analyzed print documents or has been validated by the user. Lorem ipsum is forbidden. Missing content = a "content gap" reported in docs/analyse.md or docs/prd.md, never filled freestyle.
- Figures, contacts and legal notices are copied verbatim from the print — never rephrased from memory.

## Design
- The visual identity (palette, typefaces, shapes) is extracted from the print documents (logo, brochure) and completed by the provided inspirations. `docs/design-system.md` is the single visual reference; the mockup and the HTML use only its tokens.
- A need the system doesn't cover = a "gap" to report, never to fill by inventing.
- The design prompts (dedicated section of the design system) are the bridge to Claude Design / Figma: self-contained, they carry tokens + direction + real content.

## Assets
- The original files in the print folder are NEVER modified, moved or renamed.
- Optimized images live in `assets/web/`, with a manifest `docs/assets.md` (original → optimized, dimensions, weight, usage).
- The mockup and the HTML reference the optimized assets, never the originals.

## Data & docs lifecycle
All pipeline data lives in markdown files under docs/, versioned by git when the project is a repo. No database, no state file: the state is derived from the files (the analysis is done if docs/analyse.md exists, the PRD is validated if its frontmatter says `validated: yes`) — a derived state can't go stale.

- docs/analyse.md — inventory + identity + structure + format recommendation
- docs/prd.md — site perimeter (frontmatter `validated: yes|no`)
- docs/stories.md — visitor stories
- docs/design-system.md — tokens, components, patterns, design prompts
- docs/wireframe.md — desktop sections wireframe + mobile notes
- docs/assets.md — optimized images manifest
- docs/mockup-brief.md — self-contained mockup brief (written by /ptw-mockup before any generation)

If the project is a git repo, each doc is committed at the end of its phase (`docs: <phase>`). Otherwise the files are enough.

## Definition of Done (per project)
- PRD validated by the human, perimeter and graveyard explicit
- Design system anchored in the real print identity (zero invented token)
- Wireframe mapped to real content (zero lorem)
- WebP-optimized assets with manifest
- Mockup delivered (Figma link or Claude Design output) + reusable mockup brief
