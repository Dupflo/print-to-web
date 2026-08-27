---
description: Generate the mockup — self-contained mockup brief then Figma generation via MCP (default) or Claude Design
argument-hint: (optional) figma | claude-design | brief-only
---
# ptw-mockup — The mockup, anchored in the system

Use this template for the brief:
@templates/mockup-brief.md

If nothing was injected above (the template file is missing — typical of a global install without a project init), STOP: "templates/mockup-brief.md not found — run `~/.claude/print-to-web/install.sh init` (or the curl installer with `init`)". Never rebuild the structure from memory.

## Gate (mechanical, fail-closed)
1. Does docs/prd.md contain `validated: yes` in its frontmatter? No → STOP: "PRD not validated — rerun /ptw-brief for the validation checkpoint." No file, no marker → no mockup. No exceptions.
2. Do docs/design-system.md and docs/wireframe.md exist? Missing → STOP pointing to the command.
3. Does docs/assets.md exist? Missing → warn (the mockup will use image placeholders named after the print folder) but continue if the user confirms.
4. Advisory: `grep -l 'Review passed: no' docs/reviews/*.md` → surface the failed review's major findings and ask whether to fix first or proceed anyway. No review at all → offer /ptw-review in one line, don't insist.

## Step 1 — The mockup brief (always, whatever the tool)
Write docs/mockup-brief.md BEFORE any generation (in the user's language): a self-contained document that would let any tool (or any designer) produce the mockup without reading anything else. It compiles: the design system tokens, the visual direction (inspiration invariants), **the design system's "Contested arbitrations" table copied verbatim at the top** (so open disagreements reach the presentation table instead of dying between two phases), section by section the wireframe with the real content and the associated optimized asset (`assets/web/…` path), and the Do/Don't. Content gaps: point to docs/gaps.md and list only the zones the mockup must show under the CONTENT GAP marker. Nothing invented: everything comes from the pipeline docs.

## Step 2 — The tool
$ARGUMENTS picks the tool if provided. Otherwise ask via AskUserQuestion: **Figma via MCP** (default — the mockup lands directly in Figma, reworkable by the designer) / **Claude Design** (generation there, manual Figma export afterwards) / **Brief only** (docs/mockup-brief.md is the deliverable, to paste into the designer's tool).

### Figma via MCP
1. The Figma MCP tools must be available (otherwise: tell the user to open the Figma connection in Claude, and fall back to "Brief only").
2. First read the `figma-generate-design` skill (or failing that `figma-use` / the skill://figma resource) — mandatory before calling use_figma.
3. **Never upload WebP to Figma.** The API accepts it without error, but the canvas doesn't decode it: you get empty frames and nothing fails. Before uploading, convert every `assets/web/*.webp` into `assets/web/figma/` — JPEG for photos, PNG for anything flat or transparent (logos, plans) — with `sips` or `magick`, and upload only from that mirror. The WebP files stay the web deliverable; the mirror exists only for Figma.
4. Create a new Figma file named after the project, upload the converted assets, then generate the mockup section by section following docs/mockup-brief.md. Desktop frame 1440; a 390 mobile frame for the hero and one representative section; one frame per overlay listed in the brief (popup shown open over a dimmed page background — secondary content must be visible in the mockup, not implied).
5. Known Figma-API traps (all field-verified, the last two are SILENT — the script succeeds, the render is wrong):
   - `counterAxisAlignItems` takes `MIN`/`MAX`/`CENTER`/`BASELINE` — not `START`.
   - `resize()` on a text node freezes `textAutoResize` to `NONE` → text clipped to a few px with no error. Set auto-resize explicitly after any resize.
   - Opacity passed alongside `setBoundVariableForPaint` is dropped → overlays at 100%, background photos invisible. Re-apply opacity after binding.
6. Verify with a **screenshot per section, not just the full page** — on a page thousands of px tall, an overview shows none of the silent defects above. Check each against the design system's Do/Don't; fix flagrant deviations (colors outside the palette, unplanned substitution font, clipped text, opaque overlays).
7. Deliver the Figma file link.

### Claude Design
Provide the content of docs/mockup-brief.md as the prompt, section by section if the tool requires it. Remember the output will be reworked in Figma: clean layer naming matters.

If the project is a git repo, commit the brief (`docs: mockup brief`).

End with: "Mockup generated (<tool>): <link or location>. Reusable brief: docs/mockup-brief.md. Bonus: /ptw-html for a navigable prototype." (in the user's language).
