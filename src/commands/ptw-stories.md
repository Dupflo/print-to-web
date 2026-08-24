---
description: User stories visiteur, légères et cohérentes — jamais overkill pour un site vitrine
allowed-tools:
  - Read
  - Write
  - Bash
---
# ptw-stories — Stories visiteur, à l'échelle du projet

Utilise ce template comme structure de sortie :
@templates/stories.md

Fail-closed : docs/prd.md doit exister. Absent → STOP : "Pas de PRD — lance /ptw-brief d'abord."

Un site vitrine n'est pas un SaaS : les stories servent à vérifier que chaque section a une raison d'être et un critère de réussite observable, pas à découper du développement. Reste à l'échelle.

## Règles
- Une story = un visiteur, un besoin, un critère observable. Format : "En tant que <profil du PRD>, je veux <action> afin de <bénéfice>."
- 5 à 12 stories maximum. Au-delà, c'est le signe que le PRD a un périmètre flou — retourne le dire plutôt que d'empiler.
- Chaque story se rattache à une section ou fonctionnalité du PRD. Une story orpheline (aucune section ne la sert) = un trou à signaler. Une section orpheline (aucune story ne la justifie) = un candidat graveyard à signaler.
- Pas de stories techniques ("en tant que dev…"), pas de stories d'admin sauf si le PRD prévoit un back-office.
- Ids : `s01-<slug-court>`, réutilisés tels quels partout (wireframe, maquette).

## Déroulé
1. Lis docs/prd.md (cibles, sections, CTA, fonctionnalités).
2. Écris les stories, priorisées : celles qui portent le CTA principal d'abord.
3. Vérifie la couverture dans les deux sens (story ↔ section) et note les écarts dans la section "Écarts" du fichier.
4. Écris docs/stories.md. Si le projet est un repo git, commite (`docs: stories`).

Termine par : "Stories prêtes dans docs/stories.md (<n> stories). Prochaine étape : /ptw-design-system"
