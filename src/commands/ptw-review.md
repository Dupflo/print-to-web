---
description: Fresh-eyes review of the pipeline docs by a DIFFERENT agent — Codex CLI if available, otherwise a fresh-context subagent. Clarity for non-technical readers, cross-doc coherence, verbatim fidelity.
argument-hint: (optional) analyse | prd | stories | design-system | wireframe | assets | mockup-brief | all (default: all existing docs)
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Bash
  - Agent
  - AskUserQuestion
---
# ptw-review — A different pair of eyes on the docs

The whole point is a review by an agent that did NOT write the docs. You are FORBIDDEN from reviewing inline in this conversation: the context that produced the docs cannot judge them.

Scope: $ARGUMENTS, resolved against the existing docs/ files (default: every pipeline doc present). Nothing to review → STOP: "No docs yet — the pipeline starts with /ptw-analyze."

## Step 1 — Pick the reviewer
1. Is the Codex CLI available (`command -v codex`)? If yes, ask via AskUserQuestion: "Review with?" — **Codex (different model, strongest cross-check)** / Claude subagent (fresh context). If no, use the Claude subagent without asking.
2. Either way the reviewer is read-only: it reads docs/ (and the print folder for verbatim checks), it writes nothing — YOU write the report from its findings.

## Step 2 — The review contract (give it to the reviewer verbatim, self-contained)
The reviewer receives: the list of files to read (the in-scope docs/ files, docs/analyse.md always included as the source of truth, the print folder path), the project language, and this checklist:

1. **Clarity for a non-technical reader.** The docs are read by a designer and their client. Flag every unexplained technical term ("scope creep", "CTA", "above the fold", "token", "responsive", "wireframe" used without a gloss…), every sentence that needs re-reading, every English term left in a non-English doc. For each: quote it, say where, propose a plain rewording.
2. **Cross-doc coherence.** Every PRD section appears in the wireframe (and the mockup brief if present); every secondary content item has its mechanism, its trigger AND its overlay block; stories ↔ sections coverage both ways; the chosen format is the same everywhere; assets referenced by the wireframe exist in the manifest.
3. **Fidelity to the print.** Figures, contacts and legal notices in the docs match docs/analyse.md verbatim (and it matches the print). No lorem ipsum. No content gap silently filled with invented text.
4. **Gates.** Frontmatter markers consistent with reality (a `validated: yes` PRD that later changed substantially is a finding).

Each finding: severity (major = misleads the client or breaks a rule / minor = polish), location (file + section), quote, suggested fix. The reviewer must NOT rewrite the docs.

Codex path: run `codex exec` non-interactively with that contract as the prompt and capture stdout. Claude path: spawn a read-only subagent with the same contract.

## Step 3 — The report
Write docs/reviews/<scope>.md (in the user's language): findings grouped by severity, then exactly these two final lines (verbatim keys, they are grepped):

    Issues: <n>
    Review passed: <yes|no>

`no` = at least one major finding. The review is advisory — it blocks nothing mechanically — but /ptw-mockup and the orchestrator should surface a failed review if one exists. Never soften a finding to pass.

If the project is a git repo, commit (`docs: review <scope>`).

End with: "Review (<reviewer>) in docs/reviews/<scope>.md — <n> findings, passed: <yes/no>. Fix the majors then rerun /ptw-review <scope>." (in the user's language).
