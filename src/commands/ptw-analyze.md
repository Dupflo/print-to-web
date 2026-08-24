---
description: Analyser le dossier print (plaquette, flyers, logos, photos) — inventaire des assets, identité visuelle, structure de contenu, recommandation de format web
argument-hint: <chemin du dossier print>
allowed-tools:
  - Read
  - Glob
  - Bash
  - Write
  - AskUserQuestion
---
# ptw-analyze — Analyse du dossier print

Dossier à analyser : $ARGUMENTS (si vide, demande le chemin — ne devine jamais).

Utilise ce template comme structure de sortie :
@templates/analyse.md

Cette commande ne pose PAS les questions de cadrage (c'est /ptw-brief). Elle produit les faits qui rendront le questionnaire intelligent : ce que contient le dossier, l'identité visuelle réelle, le volume de contenu, et une recommandation de format argumentée.

## Déroulé

### Étape 1 — Inventaire
Liste récursivement le dossier (ignore .DS_Store). Classe chaque fichier : plaquette/brochure (PDF), logo (et ses variantes), perspective/visuel 3D, photo, plan, carte de visite, autre. Relève dimensions et poids (`sips -g pixelWidth -g pixelHeight` ou équivalent, en lecture seule).

### Étape 2 — Lecture du contenu
- Lis la plaquette page par page (Read gère les PDF ; PDF > 10 pages : lis par tranches via `pages`). Si la lecture PDF échoue, extrais le texte autrement (markitdown, `sips` page 1) et signale la limite.
- Regarde les images clés (logos, une perspective, un échantillon de photos) pour juger leur usage web pressenti et leur qualité.
- Reconstitue la structure éditoriale : sections de la plaquette, messages clés, chiffres, contacts, mentions légales. Les chiffres et contacts sont recopiés verbatim.

### Étape 3 — Identité visuelle
Extrais du logo et de la plaquette : palette (hex approximatifs, en le disant), typographies identifiables (+ équivalent web plausible si la fonte print n'est pas libre — marqué "à confirmer"), formes et motifs graphiques récurrents (ex. les branches d'un logo réutilisées en éléments de layout). Tu constates, tu n'inventes rien.

### Étape 4 — Recommandation de format
Propose one page / multipage / one page + pages annexes, argumentée par : volume de contenu réel, nombre de sections autonomes, cibles pressenties, présence de contenus à cycle de vie propre (actualités, catalogue). C'est une recommandation — la décision se prend dans /ptw-brief.

### Étape 5 — Écriture
Remplis chaque section du template. Les trous de contenu (pas de photo d'équipe, pas de texte "à propos", contact incomplet…) vont dans "Trous & questions ouvertes" — jamais comblés en freestyle. Écris docs/analyse.md. Si le projet est un repo git, commite (`docs: analyse`).

Termine par : "Analyse prête dans docs/analyse.md. Format recommandé : <format>. Prochaine étape : /ptw-brief"
