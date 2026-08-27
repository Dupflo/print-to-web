---
description: Orchestrator — runs the whole print → web pipeline with human checkpoints (PRD, visual direction, mockup tool)
argument-hint: <path to the print folder>
---
# ptw — The full pipeline, checkpoints kept

Print folder: $ARGUMENTS (required on first run; afterwards the docs state is enough).

You conduct the pipeline; the human checkpoints are non-negotiable and are actual AskUserQuestion calls — never a rhetorical sentence in your output. This is a conductor, not an autopilot. Each phase follows the contract of its dedicated command — same template, same gates, same output file. A phase whose doc already exists is skipped (the state is derived from the files). Talk to the user in the language of the print documents.

## Phase 0 — Preflight
On the first run (docs/ doesn't exist yet), apply the /ptw-doctor contract: test the tools (PDF rendering, WebP encoder, JPEG/PNG conversion) by executing them, and report everything missing at once with one install command. Three hard stops mid-pipeline is what this phase prevents. If docs/ already exists, skip unless a previous phase failed on tooling.

## Phase 1 — Analyze
docs/analyse.md missing → run the /ptw-analyze contract on $ARGUMENTS. No $ARGUMENTS and no docs/analyse.md → ask for the folder.

## Phase 2 — Brief
docs/prd.md missing or frontmatter `validated: no` → run the /ptw-brief contract (one-pass questionnaire, informed by the analysis).

PRD CHECKPOINT — mandatory, whether the PRD is new or pre-existing. If it already says `validated: yes`, continue. Otherwise present the summary (format, sections, CTA, graveyard) and ask via AskUserQuestion: "Validate this PRD?" — Validate / Modify / Stop. An existing file does NOT count as validation. On Validate, set `validated: yes`. Otherwise: don't touch the marker, don't continue.

## Phase 3 — Stories
docs/stories.md missing → run the /ptw-stories contract (light, 5-12 stories). Quick phase, no checkpoint.

## Phase 4 — Design system
docs/design-system.md missing → run the /ptw-design-system contract (print identity + inspirations, inventing forbidden).

Visual direction CHECKPOINT — present the key tokens (palette, typefaces, motifs) and the invariants drawn from the inspirations, and ask via AskUserQuestion: "Validate this direction?" — Validate / Adjust / Stop. The mockup derives entirely from it: this is the last cheap moment to correct course.

## Phase 5 — Wireframe
docs/wireframe.md missing → run the /ptw-wireframe contract (real content, zero lorem).

## Phase 6 — Assets
docs/assets.md missing → run the /ptw-assets contract (WebP, originals untouched).

## Phase 7 — Mockup
Mechanical gate of /ptw-mockup (PRD `validated: yes` + design system + wireframe). Then offer a fresh-eyes pass in one line: "/ptw-review can have a different agent re-read everything before the mockup" — run it only on explicit request; if a review exists and says `Review passed: no`, surface its major findings and ask whether to fix first. Then tool CHECKPOINT: AskUserQuestion "Generate the mockup with?" — Figma via MCP (default) / Claude Design / Brief only. Run the /ptw-mockup contract with that choice.

## Phase 8 — HTML (optional)
Offer /ptw-html in one line. Only run it on explicit request.

End with: "Pipeline complete — mockup: <link/location>. Reusable brief: docs/mockup-brief.md." — or the exact blocking state (which phase, what's missing) — in the user's language.
