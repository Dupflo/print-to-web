---
description: One-pass framing questionnaire → PRD — site goal, validated format, perimeter, features, constraints
argument-hint: (optional) client details already known
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---
# ptw-brief — The questionnaire that locks the perimeter

Use this template as the output structure:
@templates/prd.md

If nothing was injected above (the template file is missing — typical of a global install without a project init), STOP: "templates/prd.md not found — run `~/.claude/print-to-web/install.sh init` (or the curl installer with `init`)". Never rebuild the structure from memory.

Fail-closed: docs/analyse.md must exist. Missing → STOP: "No analysis — the pipeline starts with /ptw-analyze <folder>. The questionnaire must be informed by what the print folder actually contains."

The whole point of the plugin lives here: ask the right questions IN ONE PASS so the designer/developer never goes back to the client at every phase. Every question builds on the analysis — never ask something already answered in docs/analyse.md.

Reminder (repo rules): questions and docs/prd.md are written in the user's language, in plain language — the person answering may be a designer or the client themselves. No unexplained jargon: say "la dérive du périmètre" rather than "scope creep", "le bouton d'action principal" before abbreviating to "CTA", and gloss any technical term the first time it appears.

## Workflow

### Step 1 — Re-read the analysis
Read docs/analyse.md: format recommendation, detected sections, content gaps, plus any context given in $ARGUMENTS. This is your raw material for concrete questions ("The brochure contains X — do we keep it?" rather than "What do you want?").

### Step 2 — The questionnaire (AskUserQuestion, grouped, one single pass)
Cover these axes — rephrase each question with the concrete elements from the analysis:
1. **Who is the client**: three questions that outrank half the others, field-proven — (a) who validates in last resort (the direct client, a mandating agency, someone else)? (b) what is their culture — graphic design agency, digital studio, end client with no design background? (c) are the provided inspirations THEIR work? If yes, the inspirations carry author's-choice authority (a lowercase headline is a decision, not a suggestion) — record it, it changes how every visual arbitration is settled downstream.
2. **Goal & conversion**: what is the site for (generating leads, informing, building credibility, selling)? What is THE primary CTA (form, phone, brochure download, appointment booking)?
3. **Format**: present the analysis recommendation with its arguments, as the recommended option. The user validates or corrects. The format is decided here, not before.
4. **Content perimeter**: for each section detected in the brochure, THREE possible fates — never a binary keep/drop:
   - **Primary**: visible in the page flow.
   - **Secondary**: kept, but available on demand — popup/modal, accordion, tab, annex page, download. The right home for content the client wants to keep without cluttering the page (detailed specs, floor plans, legal details…). Ask for the access mechanism and where its trigger lives.
   - **Graveyard**: genuinely dropped.
   Offer "secondary" explicitly whenever the user hesitates to drop something. Also: is there web content that doesn't exist in print (to produce — content gap)?
5. **Features**: contact form, interactive map, gallery, brochure download, multilingual, blog/news, analytics. Check what's in the perimeter — everything else is explicitly out.
6. **Constraints & context**: deadline, hosting/domain name, SEO requirements, privacy/legal notices, editorial tone (institutional, warm, technical…), priority device (desktop/mobile).
The content gaps identified in the analysis (docs/gaps.md) are submitted to the user: who produces the missing content, or does the section get dropped? Record each decision in docs/gaps.md (update the status/decision column; append new gaps with `source: brief`) — never as a separate list in the PRD.

### Step 3 — Coherence check (mandatory, BEFORE writing anything)
The questionnaire's answers must be reconciled against each other and against the visual sources — one pass produced both "no form" as a goal and "contact form" as a checked feature, in the field:
1. Cross **goal × features × perimeter**: a primary CTA with no feature carrying it, a feature contradicting the stated goal, a primary section with no content source — every contradiction goes back to the user, stated plainly, before the PRD is written.
2. Cross the **graveyard against the inspirations and reference sites**: if every inspiration shows a brochure-download button and "brochure download" is about to be buried, that's almost certainly an oversight, not a decision — flag it.
3. **The graveyard is never deduced from unchecked boxes.** Read it back explicitly: "So we are dropping: the form, the gallery, the 360° views. Confirm?" (AskUserQuestion). A missed checkbox must not become a decision to abandon what might be the client's main call-to-action.

### Step 4 — Write and validate
1. Fill every section of the template with the answers. Fill nothing the user hasn't validated. The graveyard is exhaustive — it is what keeps the project from silently growing later.
2. Present the PRD summary (format, sections, secondary content with its mechanisms, CTA, features, graveyard) and ask via AskUserQuestion: "Validate this PRD?" — options: Validate / Modify. On Validate, write `validated: yes` in the frontmatter. Otherwise iterate — the marker stays `no`.
3. Write docs/prd.md. If the project is a git repo, commit (`docs: prd`).

End with: "PRD validated in docs/prd.md. Next step: /ptw-stories (or /ptw-design-system if you skip stories)" (in the user's language).
