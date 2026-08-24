---
description: Bonus — navigable static HTML/CSS prototype, anchored on the design system and the optimized assets
allowed-tools:
  - Read
  - Glob
  - Write
  - Edit
  - Bash
---
# ptw-html — The prototype you can visit

Fail-closed: docs/design-system.md and docs/wireframe.md must exist. Missing → STOP pointing to the command. docs/mockup-brief.md is the best source if it exists (it already compiles everything); otherwise compose from design-system + wireframe + assets.

The prototype is a navigable reference for the client and a starting point for the developer — not the production site. Stay static and simple.

## Rules
- Semantic HTML (header/nav/main/section/footer), one `site/index.html` file + `site/styles.css` (+ `site/script.js` only if an interaction from the PRD requires it — mobile menu, gallery). No framework, no build.
- All tokens (colors, fonts, spacing, radius) come from docs/design-system.md, declared as CSS variables. Zero invented value. Fonts: Google Fonts if the design system planned a free substitution, otherwise a system fallback documented in a comment.
- Content: the wireframe's (hence the print's) verbatim, in the project language. The `CONTENT GAP` markers stay visible as-is in the page — they are information for the client, not a flaw to hide.
- Secondary content (the wireframe's overlays) works for real, native elements first: `<details>/<summary>` for accordions, `<dialog>` for popups (its opener is the allowed use of `site/script.js`). An overlay that stays closed in the prototype defeats its purpose.
- Images: only `assets/web/` (copy them into `site/assets/` or reference them relatively), with descriptive `alt` text, `loading="lazy"` outside the hero, `width`/`height` set.
- Responsive: mobile-first, the wireframe's mobile notes are authoritative.

## Workflow
1. Read the source docs, build the page section by section in the wireframe order.
2. Verify: open the result (browser screenshot if available, otherwise a careful re-read) and check palette, type hierarchy and the presence of every section. Fix before delivering.
3. If the project is a git repo, commit (`feat: html prototype`).

End with: "Prototype in site/index.html — open it in a browser. The pipeline is complete: /ptw-status for the final state." (in the user's language).
