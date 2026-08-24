---
description: Print-to-web pipeline map — cheat sheet
---
# ptw-help — The pipeline map

Print exactly this (translated into the user's language; only adapt the last line to the real state if docs/ exists):

```
print-to-web — from a print document to a web mockup

  /ptw <folder>           the whole pipeline, with human checkpoints

  or phase by phase:
  1. /ptw-analyze <folder>    analyze the brochure, logos, photos
                              → docs/analyse.md + recommended format
  2. /ptw-brief               THE questionnaire (one single pass) → validated PRD
                              → docs/prd.md
  3. /ptw-stories             5-12 visitor stories, never overkill
                              → docs/stories.md
  4. /ptw-design-system       print identity + inspirations → tokens + design prompts
                              → docs/design-system.md
  5. /ptw-wireframe           ASCII skeleton with real content, zero lorem
                              → docs/wireframe.md
  6. /ptw-assets              resize + WebP without degrading, originals untouched
                              → assets/web/ + docs/assets.md
  7. /ptw-mockup              Figma mockup (MCP) or Claude Design
                              → docs/mockup-brief.md + Figma file
  8. /ptw-html                bonus: navigable prototype → site/index.html

  /ptw-review [doc|all]   fresh-eyes review by a different agent (Codex
                          if installed) — clarity, coherence, fidelity
  /ptw-status             where the project stands, next command
  /ptw-update             check for a newer plugin version, apply it

Gates: no brief without analysis · no mockup without a validated PRD
       and a design system · identity never invented · lorem forbidden
```

End with the next useful command for THIS project (from the docs state), or "/ptw-analyze <folder>" if nothing has started.
