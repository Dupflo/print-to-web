---
description: Markdown design system — tokens extracted from the print identity, inspiration analysis, design prompts ready for Claude Design / Figma
argument-hint: (optional) path to the inspirations folder
allowed-tools:
  - Read
  - Glob
  - Write
  - Bash
  - AskUserQuestion
---
# ptw-design-system — The print identity translated into a web system

Use this template as the output structure:
@templates/design-system.md

If nothing was injected above (the template file is missing — typical of a global install without a project init), STOP: "templates/design-system.md not found — run `~/.claude/print-to-web/install.sh init` (or the curl installer with `init`)". Never rebuild the structure from memory.

## Execution contract (non-negotiable)
You are FORBIDDEN from:
- Inventing a visual identity from nothing.
- Producing a generic default design system (random colors, imaginary components).

Fail-closed: docs/analyse.md must exist (the print identity is described there). Missing → STOP: "No analysis — run /ptw-analyze first." If the analysis extracted no usable identity AND no inspirations folder is provided → STOP, ask for the visual source.

## Workflow

### Step 1 — Gather the sources
1. The print identity: palette, typefaces, shapes and motifs recorded in docs/analyse.md. Re-check the hex values against the source files (logo) if in doubt.
2. The inspirations: $ARGUMENTS, or an `inspirations/` folder if it exists, or ask. Read each image and describe what it establishes: hero structure, image treatment (organic shapes, full-bleed…), the role of the logo's motifs in the layout, overall tone. If several variants coexist, record what they share (the invariants) and what sets them apart (the open options) — and have the user settle the open options via AskUserQuestion.
3. The PRD if it exists: editorial tone and priority device influence the choices (type scale, density).

### Step 2 — Structure
Fill the template:
- Tokens: palette (hex, primary/secondary/background/text roles), web typefaces (the real font if free, otherwise a Google Fonts equivalent marked "substitution"), type scale, spacing, radius, shadows.
- Motifs & shapes: the graphic elements taken from the print (logo shapes, cutouts, rules) and their authorized web usage.
- Components: only the ones the wireframe/PRD calls for (buttons, key-figure card, contact card, nav, footer…). Name + usage + variants.
- UI patterns: image treatment, form states, responsive.
- Do / Don't: what the inspirations and the print impose or exclude.
- **Contested arbitrations**: when two legitimate sources disagree (e.g. the print uses CAPITALS, the inspirations use lowercase — and the inspirations' author is the mandating agency), do NOT settle it silently as an "option". Record it in the dedicated table: decision / taken by / what it contradicts / when to reopen. If nobody with authority has decided, the decision column says "open — to settle at presentation". /ptw-mockup copies this table into the brief.
- **Design prompts**: for each major section of the site, a self-contained prompt (direction + tokens + real content) ready to paste into Claude Design or Figma Make. This is the bridge to the mockup tools.

### Step 3 — Write
Write docs/design-system.md (in the user's language) — the project's single visual reference, consumed by /ptw-wireframe, /ptw-mockup and /ptw-html. If the project is a git repo, commit (`docs: design system`).

End with: "Design system captured in docs/design-system.md. Next step: /ptw-wireframe" (in the user's language).
