---
description: Bonus — prototype HTML/CSS statique navigable, ancré sur le design system et les assets optimisés
allowed-tools:
  - Read
  - Glob
  - Write
  - Edit
  - Bash
---
# ptw-html — Le prototype qui se visite

Fail-closed : docs/design-system.md et docs/wireframe.md doivent exister. Manquant → STOP en pointant la commande. docs/mockup-brief.md est la meilleure source s'il existe (il compile déjà tout) ; sinon compose depuis design-system + wireframe + assets.

Le prototype est une référence navigable pour le client et une base de départ pour le dev — pas le site de production. Reste statique et simple.

## Règles
- HTML sémantique (header/nav/main/section/footer), un fichier `site/index.html` + `site/styles.css` (+ `site/script.js` seulement si une interaction du PRD l'exige — menu mobile, galerie). Pas de framework, pas de build.
- Tous les tokens (couleurs, fontes, espacements, radius) viennent de docs/design-system.md, déclarés en variables CSS. Zéro valeur inventée. Fontes : Google Fonts si le design system prévoit une substitution libre, sinon fallback système documenté en commentaire.
- Contenu : celui du wireframe (donc du print) verbatim. Les `TROU DE CONTENU` restent visibles tels quels dans la page — c'est une information pour le client, pas un défaut à masquer.
- Images : uniquement `assets/web/` (copie-les dans `site/assets/` ou référence-les en relatif), avec `alt` descriptifs, `loading="lazy"` hors hero, `width`/`height` posés.
- Responsive : mobile-first, les notes mobile du wireframe font foi.

## Déroulé
1. Lis les docs sources, construis la page section par section dans l'ordre du wireframe.
2. Vérifie : ouvre le rendu (screenshot navigateur si disponible, sinon relecture attentive) et contrôle palette, hiérarchie typographique et présence de chaque section. Corrige avant de livrer.
3. Si le projet est un repo git, commite (`feat: prototype html`).

Termine par : "Prototype dans site/index.html — ouvre-le dans un navigateur. Le pipeline est complet : /ptw-status pour l'état final."
