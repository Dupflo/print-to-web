---
description: Lightweight, coherent visitor stories — never overkill for a showcase site
allowed-tools:
  - Read
  - Write
  - Bash
---
# ptw-stories — Visitor stories, at the project's scale

Use this template as the output structure:
@templates/stories.md

Fail-closed: docs/prd.md must exist. Missing → STOP: "No PRD — run /ptw-brief first."

A showcase site is not a SaaS: the stories exist to check that every section has a reason to exist and an observable success criterion, not to slice development work. Stay at scale.

## Rules
- One story = one visitor, one need, one observable criterion. Format: "As a <profile from the PRD>, I want <action> so that <benefit>."
- 5 to 12 stories maximum. Beyond that, it's a sign the PRD perimeter is fuzzy — go say so instead of piling up.
- Every story attaches to a section or feature of the PRD. An orphan story (no section serves it) = a gap to report. An orphan section (no story justifies it) = a graveyard candidate to report.
- No technical stories ("as a dev…"), no admin stories unless the PRD includes a back office.
- Ids: `s01-<short-slug>`, reused verbatim everywhere (wireframe, mockup).

## Workflow
1. Read docs/prd.md (audiences, sections, CTA, features).
2. Write the stories, prioritized: the ones carrying the primary CTA first.
3. Check coverage both ways (story ↔ section) and record the gaps in the file's "Gaps" section.
4. Write docs/stories.md (in the user's language). If the project is a git repo, commit (`docs: stories`).

End with: "Stories ready in docs/stories.md (<n> stories). Next step: /ptw-design-system" (in the user's language).
