---
description: Optimiser les images du dossier print pour le web — resize + WebP sans dégradation visible, originaux intacts, manifeste des correspondances
argument-hint: (optionnel) chemin du dossier print si docs/analyse.md n'existe pas
allowed-tools:
  - Read
  - Glob
  - Write
  - Bash
---
# ptw-assets — Du print au web sans casser les images

Utilise ce template pour le manifeste :
@templates/assets.md

Règle absolue : les fichiers originaux ne sont JAMAIS modifiés, déplacés ni renommés. Tout ce qui est produit va dans `assets/web/`.

## Déroulé

### Étape 1 — Sélection
Pars de docs/wireframe.md (les assets réellement utilisés) s'il existe, sinon de l'inventaire de docs/analyse.md, sinon du dossier passé en $ARGUMENTS. N'optimise que ce qui servira au site — pas les 40 photos du dossier si le wireframe en utilise 6. Signale ce que tu laisses de côté.

### Étape 2 — Outils
Détecte ce qui est disponible, dans cet ordre de préférence : `cwebp` (contrôle qualité fin), `magick`/`convert` (ImageMagick), `sips` (macOS — vérifie que l'export WebP est supporté : `sips -s format webp` sur un fichier test). Rien ne permet d'encoder du WebP → propose l'installation (`brew install webp`) et STOP, n'invente pas un format de repli sans le dire.

### Étape 3 — Conversion
Cibles par usage (jamais d'upscale — si l'original est plus petit, garde sa taille) :
- Hero / images plein écran : largeur max 2560 px, qualité WebP 82
- Images de section / galerie : largeur max 1600 px, qualité 82
- Vignettes / cartes : largeur max 800 px, qualité 80
- Logos : si un vecteur (SVG/PDF) existe, note-le comme format à privilégier ; sinon PNG transparent conservé + variante WebP. Jamais de fond ajouté.
- Plans / documents techniques lisibles : qualité 90 — le texte doit rester net (c'est le cas "sans les dégrader" du besoin).
Nommage : `assets/web/<usage>-<slug>.webp` (ex. `hero-perspective-sud.webp`), prévisible et lisible.

### Étape 4 — Vérification
Pour chaque image : compare poids avant/après et vérifie visuellement (Read) au moins le hero et un plan — artefacts visibles ou texte flou → remonte la qualité et refais. Rapporte le gain total.

### Étape 5 — Manifeste
Écris docs/assets.md : original → optimisé, dimensions, poids avant/après, usage prévu (section du wireframe). Si le projet est un repo git, commite (`docs: assets` — inclure assets/web/).

Termine par : "<n> assets optimisés dans assets/web/ (−<x> % de poids total). Manifeste : docs/assets.md. Prochaine étape : /ptw-mockup"
