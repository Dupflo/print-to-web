---
description: Wireframe maison en markdown/ASCII — sections desktop + notes mobile, mappé sur le contenu réel du print
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---
# ptw-wireframe — Le squelette du site, avec du vrai contenu

Utilise ce template comme structure de sortie :
@templates/wireframe.md

Fail-closed : docs/prd.md doit exister (il fixe le format et les sections). Absent → STOP : "Pas de PRD — lance /ptw-brief d'abord." docs/design-system.md est recommandé mais pas bloquant : sans lui, le wireframe reste purement structurel (aucune indication visuelle).

Le wireframe est un contrat de structure, pas un dessin : ordre des sections, hiérarchie de l'information dans chaque section, et surtout le mapping vers le contenu réel. Lorem ipsum interdit — chaque zone de texte cite son contenu source (plaquette, page/section) ou porte la mention `TROU DE CONTENU` héritée du PRD.

## Déroulé
1. Lis docs/prd.md (format, sections retenues, CTA, priorités) et docs/stories.md si présent (une story par section = la raison d'être de la section, mets-la en commentaire).
2. Pour chaque section, produis :
   - Un schéma ASCII desktop (blocs, proportions grossières, position du CTA).
   - Le mapping contenu : chaque bloc → texte réel (cité ou résumé avec référence) + asset pressenti (nom de fichier du dossier print).
   - Les notes mobile : ce qui s'empile, ce qui disparaît, ce qui se transforme (ex. tableau → cartes).
3. Ordre des sections = un parcours de conversion : le CTA principal du PRD doit être atteignable sans scroll profond et répété en fin de page.
4. Signale les décisions structurantes ouvertes (ex. plans d'étage en galerie ou en onglets ?) via AskUserQuestion si elles changent la maquette — sinon tranche et note-le.
5. Écris docs/wireframe.md. Si le projet est un repo git, commite (`docs: wireframe`).

Termine par : "Wireframe prêt dans docs/wireframe.md (<n> sections). Prochaine étape : /ptw-assets"
