---
description: Questionnaire de cadrage en une passe → PRD — objectif du site, format validé, périmètre, fonctionnalités, contraintes
argument-hint: (optionnel) précisions du client déjà connues
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---
# ptw-brief — Le questionnaire qui fixe le périmètre

Utilise ce template comme structure de sortie :
@templates/prd.md

Fail-closed : docs/analyse.md doit exister. Absent → STOP : "Pas d'analyse — le pipeline commence par /ptw-analyze <dossier>. Le questionnaire doit être éclairé par ce que contient réellement le dossier print."

Le but de tout le plugin est ici : poser les bonnes questions EN UNE FOIS pour que le designer/développeur ne revienne pas vers le client à chaque phase. Chaque question s'appuie sur l'analyse — jamais de question dont la réponse est déjà dans docs/analyse.md.

## Déroulé

### Étape 1 — Relire l'analyse
Lis docs/analyse.md : recommandation de format, sections détectées, trous de contenu, contexte fourni en $ARGUMENTS. C'est ta matière première pour formuler des questions concrètes ("La plaquette contient X — on le garde ?" plutôt que "Que voulez-vous ?").

### Étape 2 — Le questionnaire (AskUserQuestion, groupé, une seule passe)
Couvre ces axes — reformule chaque question avec les éléments concrets de l'analyse :
1. **Objectif & conversion** : à quoi sert le site (générer des leads, informer, crédibiliser, vendre) ? Quel est LE CTA principal (formulaire, téléphone, téléchargement de la plaquette, prise de RDV) ?
2. **Format** : présente la recommandation de l'analyse avec ses arguments, en option recommandée. L'utilisateur valide ou corrige. C'est ici que le format se décide, pas avant.
3. **Périmètre de contenu** : parmi les sections détectées dans la plaquette, lesquelles passent au web, lesquelles vont au graveyard ? Y a-t-il du contenu web qui n'existe pas dans le print (à produire — trou de contenu) ?
4. **Fonctionnalités** : formulaire de contact, carte interactive, galerie, téléchargement de la plaquette, multilingue, blog/actus, analytics. Coche ce qui est dans le périmètre — le reste est explicitement dehors.
5. **Contraintes & contexte** : deadline, hébergement/nom de domaine, exigences SEO, RGPD/mentions légales, ton éditorial (institutionnel, chaleureux, technique…), device prioritaire (desktop/mobile).
Les trous de contenu identifiés dans l'analyse sont soumis à l'utilisateur : qui produit le contenu manquant, ou la section saute-t-elle ?

### Étape 3 — Écriture et validation
1. Remplis chaque section du template avec les réponses. Ne remplis rien que l'utilisateur n'a pas validé. Le graveyard est exhaustif — c'est lui qui tue le scope creep.
2. Présente le résumé du PRD (format, sections, CTA, fonctionnalités, graveyard) et demande via AskUserQuestion : "Valider ce PRD ?" — options : Valider / Modifier. Sur Valider, écris `validated: yes` dans le frontmatter. Sinon, itère — le marqueur reste `no`.
3. Écris docs/prd.md. Si le projet est un repo git, commite (`docs: prd`).

Termine par : "PRD validé dans docs/prd.md. Prochaine étape : /ptw-stories (ou /ptw-design-system si tu sautes les stories)"
