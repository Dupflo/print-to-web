---
description: Carte du pipeline print-to-web — antisèche
---
# ptw-help — La carte du pipeline

Affiche exactement ceci (adapte seulement la dernière ligne à l'état réel si docs/ existe) :

```
print-to-web — d'un document print à une maquette web

  /ptw <dossier>          tout le pipeline, avec checkpoints humains

  ou phase par phase :
  1. /ptw-analyze <dossier>   analyse la plaquette, les logos, les photos
                              → docs/analyse.md + format recommandé
  2. /ptw-brief               LE questionnaire (une seule passe) → PRD validé
                              → docs/prd.md
  3. /ptw-stories             5-12 stories visiteur, jamais overkill
                              → docs/stories.md
  4. /ptw-design-system       identité print + inspirations → tokens + prompts design
                              → docs/design-system.md
  5. /ptw-wireframe           squelette ASCII avec le vrai contenu, zéro lorem
                              → docs/wireframe.md
  6. /ptw-assets              resize + WebP sans dégrader, originaux intacts
                              → assets/web/ + docs/assets.md
  7. /ptw-mockup              maquette Figma (MCP) ou Claude Design
                              → docs/mockup-brief.md + fichier Figma
  8. /ptw-html                bonus : prototype navigable → site/index.html

  /ptw-status             où en est le projet, prochaine commande

Gates : pas de brief sans analyse · pas de maquette sans PRD validé
        ni design system · identité jamais inventée · lorem interdit
```

Termine par la prochaine commande utile pour CE projet (via l'état des docs), ou "/ptw-analyze <dossier>" si rien n'a démarré.
