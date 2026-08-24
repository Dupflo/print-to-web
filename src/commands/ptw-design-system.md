---
description: Design system markdown — tokens extraits de l'identité print, analyse des inspirations visuelles, prompts design prêts pour Claude Design / Figma
argument-hint: (optionnel) chemin du dossier d'inspirations
allowed-tools:
  - Read
  - Glob
  - Write
  - Bash
  - AskUserQuestion
---
# ptw-design-system — L'identité print traduite en système web

Utilise ce template comme structure de sortie :
@templates/design-system.md

## Contrat d'exécution (non négociable)
Il t'est INTERDIT de :
- Inventer une identité visuelle à partir de rien.
- Produire un design system générique par défaut (couleurs au hasard, composants imaginaires).

Fail-closed : docs/analyse.md doit exister (l'identité print y est décrite). Absent → STOP : "Pas d'analyse — lance /ptw-analyze d'abord." Si l'analyse n'a extrait aucune identité exploitable ET qu'aucun dossier d'inspirations n'est fourni → STOP, demande la source visuelle.

## Déroulé

### Étape 1 — Rassembler les sources
1. L'identité print : palette, typographies, formes et motifs relevés dans docs/analyse.md. Revérifie les hex sur les fichiers sources (logo) si un doute existe.
2. Les inspirations : $ARGUMENTS, ou un dossier `inspirations/` s'il existe, ou demande. Lis chaque image et décris ce qu'elle établit : structure du hero, traitement des images (formes organiques, plein cadre…), rôle des motifs du logo dans le layout, ton général. Si plusieurs variantes coexistent, relève ce qu'elles ont en commun (les invariants) et ce qui les distingue (les options ouvertes) — et fais trancher les options ouvertes via AskUserQuestion.
3. Le PRD s'il existe : ton éditorial et device prioritaire influencent les choix (échelle typographique, densité).

### Étape 2 — Structurer
Remplis le template :
- Tokens : palette (hex, rôles primaire/secondaire/fond/texte), typographies web (fonte réelle si libre, sinon équivalent Google Fonts marqué "substitution"), échelle typographique, espacements, radius, ombres.
- Motifs & formes : les éléments graphiques issus du print (formes du logo, découpes, filets) et leur usage web autorisé.
- Composants : uniquement ceux que le wireframe/PRD réclament (boutons, carte chiffre-clé, carte contact, nav, footer…). Nom + usage + variantes.
- Patterns UI : traitement des images, états des formulaires, responsive.
- Do / Don't : ce que les inspirations et le print imposent ou excluent.
- **Prompts design** : pour chaque grande section du site, un prompt autonome (direction + tokens + contenu réel) prêt à coller dans Claude Design ou Figma Make. C'est la passerelle vers les outils de maquette.

### Étape 3 — Écriture
Écris docs/design-system.md — l'unique référence visuelle du projet, consommée par /ptw-wireframe, /ptw-mockup et /ptw-html. Si le projet est un repo git, commite (`docs: design system`).

Termine par : "Design system capturé dans docs/design-system.md. Prochaine étape : /ptw-wireframe"
