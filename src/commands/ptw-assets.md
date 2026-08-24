---
description: Optimize the print folder images for the web — resize + WebP with no visible degradation, originals untouched, mapping manifest
argument-hint: (optional) path to the print folder if docs/analyse.md doesn't exist
allowed-tools:
  - Read
  - Glob
  - Write
  - Bash
---
# ptw-assets — From print to web without breaking the images

Use this template for the manifest:
@templates/assets.md

Absolute rule: the original files are NEVER modified, moved or renamed. Everything produced goes into `assets/web/`.

## Workflow

### Step 1 — Selection
Start from docs/wireframe.md (the assets actually used) if it exists, otherwise from the inventory in docs/analyse.md, otherwise from the folder passed as $ARGUMENTS. Only optimize what the site will use — not the folder's 40 photos when the wireframe uses 6. Report what you leave aside.

### Step 2 — Tools
Detect what's available, in this order of preference: `cwebp` (fine quality control), `magick`/`convert` (ImageMagick), `sips` (macOS — verify WebP export is supported: `sips -s format webp` on a test file). Nothing can encode WebP → suggest installing (`brew install webp`) and STOP; don't invent a fallback format silently.

### Step 3 — Conversion
Targets per usage (never upscale — if the original is smaller, keep its size):
- Hero / full-screen images: max width 2560 px, WebP quality 82
- Section / gallery images: max width 1600 px, quality 82
- Thumbnails / cards: max width 800 px, quality 80
- Logos: if a vector (SVG/PDF) exists, note it as the format to prefer; otherwise keep the transparent PNG + a WebP variant. Never add a background.
- Floor plans / readable technical documents: quality 90 — the text must stay sharp (this is the "without degrading them" case of the requirement).
Naming: `assets/web/<usage>-<slug>.webp` (e.g. `hero-south-view.webp`), predictable and readable, slugs in the project language.

### Step 4 — Verification
For each image: compare before/after weight and visually check (Read) at least the hero and one plan — visible artifacts or blurry text → raise the quality and redo. Report the total gain.

### Step 5 — Manifest
Write docs/assets.md (in the user's language): original → optimized, dimensions, before/after weight, planned usage (wireframe section). If the project is a git repo, commit (`docs: assets` — include assets/web/).

End with: "<n> assets optimized in assets/web/ (−<x>% total weight). Manifest: docs/assets.md. Next step: /ptw-mockup" (in the user's language).
