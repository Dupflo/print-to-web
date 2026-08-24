---
description: État du projet print → web dérivé des fichiers — phases faites, prochaine commande
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---
# ptw-status — Où en est le projet

Dérive l'état des fichiers — ne devine jamais. Bash uniquement en lecture.

1. Vérifie l'existence de chaque doc du pipeline, dans l'ordre :
   - docs/analyse.md (+ le format recommandé, grep "Recommandation")
   - docs/prd.md (+ frontmatter : `validated: yes|no` — un PRD non validé bloque la maquette)
   - docs/stories.md (+ nombre de stories)
   - docs/design-system.md
   - docs/wireframe.md (+ nombre de sections)
   - docs/assets.md (+ compter les fichiers dans assets/web/)
   - docs/mockup-brief.md (+ le lien Figma s'il y est)
   - site/index.html (bonus HTML)
2. Affiche un tableau compact : phase | état (✓ / — / bloqué) | détail. La première phase manquante est la prochaine étape ; une phase présente mais dont le gate amont a régressé (ex. PRD repassé `validated: no`) est marquée "bloqué".
3. Relève les `TROU DE CONTENU` encore présents (grep dans docs/) — c'est la liste de ce que le client doit encore fournir.

Si docs/ n'existe pas : le projet n'a pas démarré — pointe /ptw-analyze <dossier> (ou /ptw <dossier> pour tout enchaîner).

Termine par la commande la plus utile maintenant, ex. : "Next : /ptw-wireframe".
